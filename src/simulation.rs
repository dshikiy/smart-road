use std::collections::{HashMap, HashSet};

use macroquad::math::Vec2;

use crate::{
    car::Car,
    geometry::{requires_stop, Bounds},
    intersection::Intersection,
    route::{Approach, Path, Route, ROUTE_COUNT},
    stats::Stats,
    CAR_LENGTH, FIXED_DT, SAFE_DISTANCE,
};

const CELL_SIZE: f32 = 64.0;
const MAX_CARS: usize = 1024;
const AUTO_INTERVAL: f64 = 1.0;
const REQUEST_DISTANCE: f32 = 70.0;
const CLEARANCE_EPSILON: f32 = 0.1;
const MAX_CONVOY: u8 = 3;

#[derive(Default)]
struct SpatialGrid {
    cells: HashMap<(i32, i32), Vec<usize>>,
}

impl SpatialGrid {
    fn key(position: Vec2) -> (i32, i32) {
        (
            (position.x / CELL_SIZE).floor() as i32,
            (position.y / CELL_SIZE).floor() as i32,
        )
    }

    fn insert(&mut self, index: usize, position: Vec2) {
        self.cells
            .entry(Self::key(position))
            .or_default()
            .push(index);
    }

    fn update(&mut self, index: usize, old: Vec2, new: Vec2) {
        let old_key = Self::key(old);
        let new_key = Self::key(new);
        if old_key != new_key {
            if let Some(bucket) = self.cells.get_mut(&old_key) {
                if let Some(slot) = bucket.iter().position(|&value| value == index) {
                    bucket.swap_remove(slot);
                }
            }
            self.cells.entry(new_key).or_default().push(index);
        }
    }

    fn rebuild(&mut self, cars: &[Car]) {
        for bucket in self.cells.values_mut() {
            bucket.clear();
        }
        for (index, car) in cars.iter().enumerate() {
            self.insert(index, car.pose.position);
        }
    }

    fn nearby(&self, bounds: Bounds, output: &mut Vec<usize>) {
        output.clear();
        // Centers are indexed once; include the largest rotated body extent.
        let query = bounds.expanded(CAR_LENGTH + SAFE_DISTANCE);
        let low = Self::key(query.min);
        let high = Self::key(query.max);
        for y in low.1..=high.1 {
            for x in low.0..=high.0 {
                if let Some(bucket) = self.cells.get(&(x, y)) {
                    output.extend_from_slice(bucket);
                }
            }
        }
    }
}

type Pair = (u64, u64);

#[derive(Default)]
struct SafetyEvents {
    close: HashSet<Pair>,
    collision: HashSet<Pair>,
    next_close: HashSet<Pair>,
    next_collision: HashSet<Pair>,
}

impl SafetyEvents {
    fn begin(&mut self) {
        self.next_close.clear();
        self.next_collision.clear();
    }

    fn observe(&mut self, a: &Car, b: &Car, stats: &mut Stats) {
        let pair = (a.id.min(b.id), a.id.max(b.id));
        if a.bounds.gap_squared(b.bounds) < SAFE_DISTANCE * SAFE_DISTANCE - 0.001 {
            if !self.close.contains(&pair) && self.next_close.insert(pair) {
                stats.close_calls += 1;
            }
            self.next_close.insert(pair);
        }
        if a.bounds.overlaps(b.bounds) {
            if !self.collision.contains(&pair) && self.next_collision.insert(pair) {
                stats.collisions += 1;
            }
            self.next_collision.insert(pair);
        }
    }

    fn finish(&mut self) {
        std::mem::swap(&mut self.close, &mut self.next_close);
        std::mem::swap(&mut self.collision, &mut self.next_collision);
    }
}

pub struct Simulation {
    pub cars: Vec<Car>,
    pub stats: Stats,
    pub paths: [Path; ROUTE_COUNT],
    pub paused: bool,
    pub auto_spawn: bool,
    pub time: f64,
    pub neighbor_checks: u64,
    pub spawn_attempts: u64,
    pub spawned: u64,
    intersection: Intersection,
    grid: SpatialGrid,
    events: SafetyEvents,
    pending: Vec<usize>,
    lanes: [Vec<usize>; ROUTE_COUNT],
    nearby: Vec<usize>,
    accumulator: f64,
    spawn_timer: f64,
    next_id: u64,
    random_state: u64,
    convoy_grants: [u8; ROUTE_COUNT],
}

impl Simulation {
    pub fn new(seed: u64) -> Self {
        let paths = std::array::from_fn(|i| Path::for_route(Route::ALL[i]));
        let intersection = Intersection::new(&paths);
        Self {
            cars: Vec::new(),
            stats: Stats::default(),
            paths,
            paused: false,
            auto_spawn: false,
            time: 0.0,
            neighbor_checks: 0,
            spawn_attempts: 0,
            spawned: 0,
            intersection,
            grid: SpatialGrid::default(),
            events: SafetyEvents::default(),
            pending: Vec::new(),
            lanes: std::array::from_fn(|_| Vec::new()),
            nearby: Vec::new(),
            accumulator: 0.0,
            spawn_timer: 0.0,
            next_id: 1,
            random_state: seed.max(1),
            convoy_grants: [0; ROUTE_COUNT],
        }
    }

    fn random(&mut self) -> u64 {
        self.random_state ^= self.random_state << 13;
        self.random_state ^= self.random_state >> 7;
        self.random_state ^= self.random_state << 17;
        self.random_state
    }

    pub fn random_route(&mut self) -> Route {
        Route::ALL[self.random() as usize % ROUTE_COUNT]
    }

    pub fn spawn_from(&mut self, approach: Approach) -> bool {
        let route = Route::from_approach(approach, self.random() as usize);
        self.spawn(route)
    }

    pub fn spawn(&mut self, route: Route) -> bool {
        self.spawn_attempts += 1;
        if self.cars.len() >= MAX_CARS {
            return false;
        }
        let cruise = 90.0 + (self.random() % 3000) as f32 / 100.0;
        let car = Car::new(self.next_id, route, &self.paths[route as usize], cruise);
        self.grid.nearby(car.bounds, &mut self.nearby);
        if self.nearby.iter().any(|&index| {
            car.bounds.gap_squared(self.cars[index].bounds)
                < (SAFE_DISTANCE + CLEARANCE_EPSILON).powi(2)
        }) {
            return false;
        }
        self.grid.insert(self.cars.len(), car.pose.position);
        self.cars.push(car);
        self.stats.observe_speed(0.0);
        self.next_id += 1;
        self.spawned += 1;
        true
    }

    /// Rendering frequency never changes physics, automatic traffic or simulation timers.
    pub fn advance(&mut self, seconds: f64) {
        if self.paused || !seconds.is_finite() || seconds <= 0.0 {
            return;
        }
        self.accumulator += seconds;
        while self.accumulator + 1e-9 >= FIXED_DT {
            self.step();
            self.accumulator = (self.accumulator - FIXED_DT).max(0.0);
        }
    }

    fn reserve_routes(&mut self) {
        let mut occupied = 0;
        let mut active_counts = [0; ROUTE_COUNT];
        self.pending.clear();
        for (index, car) in self.cars.iter_mut().enumerate() {
            let path = &self.paths[car.route as usize];
            if car.progress >= path.exit_distance {
                car.reserved = false;
            } else if car.reserved {
                occupied |= 1 << car.route as usize;
                active_counts[car.route as usize] += 1;
            } else if car.detected_at.is_some()
                && path.entry_distance - car.progress <= REQUEST_DISTANCE
            {
                self.pending.push(index);
            }
        }
        for (route, count) in active_counts.iter().enumerate() {
            if *count == 0 {
                self.convoy_grants[route] = 0;
            }
        }
        self.pending.sort_unstable_by(|&a, &b| {
            self.cars[a]
                .detected_at
                .unwrap()
                .total_cmp(&self.cars[b].detected_at.unwrap())
                .then(self.cars[a].id.cmp(&self.cars[b].id))
        });
        let mut older_waiting = 0;
        for &index in &self.pending {
            let car = &mut self.cars[index];
            let route = car.route as usize;
            let joins_convoy =
                occupied & (1 << route) != 0 && self.convoy_grants[route] < MAX_CONVOY;
            let available = self.intersection.can_reserve(car.route, occupied)
                && (joins_convoy
                    || (occupied & (1 << route) == 0
                        && self.intersection.can_reserve(car.route, older_waiting)));
            if available {
                car.reserved = true;
                occupied |= 1 << route;
                self.convoy_grants[route] += 1;
            } else {
                // Stop new conflicting convoys from starving an older request.
                older_waiting |= 1 << car.route as usize;
            }
        }
    }

    fn sweep_is_clear(&mut self, index: usize, distance: f32) -> bool {
        let car = &self.cars[index];
        let path = &self.paths[car.route as usize];
        let next = Bounds::for_pose(path.pose(car.progress + distance));
        let middle = Bounds::for_pose(path.pose(car.progress + distance * 0.5));
        let swept = car.bounds.union(next).union(middle).expanded(0.05);
        self.grid.nearby(swept, &mut self.nearby);
        for &other in &self.nearby {
            if other != index {
                self.neighbor_checks += 1;
                if swept.gap_squared(self.cars[other].bounds) < (SAFE_DISTANCE + 0.01).powi(2) {
                    return false;
                }
            }
        }
        true
    }

    fn move_car(&mut self, index: usize, leader: Option<usize>) {
        let car = &self.cars[index];
        let path = &self.paths[car.route as usize];
        let finish_distance = path.length - car.progress;
        let mut clearance = finish_distance;
        if !car.reserved && car.progress < path.exit_distance {
            clearance = clearance.min(path.entry_distance - car.progress);
        }
        if let Some(front) = leader {
            let gap = self.cars[front].progress - car.progress - CAR_LENGTH;
            clearance = clearance.min(if requires_stop(gap) {
                0.0
            } else {
                gap - SAFE_DISTANCE - CLEARANCE_EPSILON
            });
        }
        clearance = clearance.max(0.0);
        // The last few pixels are an offscreen finish, not an obstacle to brake for.
        let mut target = if !car.reserved && car.progress < path.exit_distance {
            car.target_speed((path.entry_distance - car.progress).max(0.0))
        } else {
            car.cruise_speed
        };
        if let Some(front) = leader {
            // Match a moving leader instead of braking to crawl speed at every headway.
            target = target
                .min((self.cars[front].speed + (clearance - car.speed * 0.35) * 1.5).max(0.0));
            target = target.min((2.0 * crate::BRAKING * clearance).sqrt());
        }
        let (mut speed, requested) = car.integrate(target, FIXED_DT as f32);
        let mut distance = requested.min(clearance);
        let mut blocked = false;
        if distance > 0.00001 && !self.sweep_is_clear(index, distance) {
            blocked = true;
            let mut low = 0.0;
            let mut high = distance;
            for _ in 0..12 {
                let middle = (low + high) * 0.5;
                if self.sweep_is_clear(index, middle) {
                    low = middle;
                } else {
                    high = middle;
                }
            }
            distance = if low > 0.0001 { low } else { 0.0 };
        }
        let finishes = distance >= finish_distance;
        if !finishes && distance + 0.0001 < requested {
            speed = speed.min(distance / FIXED_DT as f32);
        }
        let car = &mut self.cars[index];
        if blocked && !car.was_blocked {
            self.stats.prevented_conflicts += 1;
        }
        car.was_blocked = blocked;
        let old = car.pose.position;
        // Preserve velocity and interpolate the exit instant when leaving the canvas.
        car.advance(
            &self.paths[car.route as usize],
            if finishes { requested } else { distance },
            speed,
            self.time,
            FIXED_DT,
        );
        self.grid.update(index, old, car.pose.position);
        self.stats.observe_speed(car.speed);
    }

    fn step(&mut self) {
        if self.auto_spawn {
            self.spawn_timer += FIXED_DT;
            if self.spawn_timer + 1e-9 >= AUTO_INTERVAL {
                self.spawn_timer -= AUTO_INTERVAL;
                let route = self.random_route();
                self.spawn(route);
            }
        }
        self.reserve_routes();
        for lane in &mut self.lanes {
            lane.clear();
        }
        for (index, car) in self.cars.iter().enumerate() {
            self.lanes[car.route as usize].push(index);
        }
        for lane in &mut self.lanes {
            lane.sort_unstable_by(|&a, &b| self.cars[b].progress.total_cmp(&self.cars[a].progress));
        }
        for route in 0..ROUTE_COUNT {
            for slot in 0..self.lanes[route].len() {
                let index = self.lanes[route][slot];
                let leader = slot
                    .checked_sub(1)
                    .map(|previous| self.lanes[route][previous]);
                self.move_car(index, leader);
            }
        }
        self.events.begin();
        for index in 0..self.cars.len() {
            self.grid.nearby(self.cars[index].bounds, &mut self.nearby);
            for &other in &self.nearby {
                if other > index {
                    self.events
                        .observe(&self.cars[index], &self.cars[other], &mut self.stats);
                }
            }
        }
        self.events.finish();
        let before = self.cars.len();
        self.cars.retain(|car| {
            if car.progress >= self.paths[car.route as usize].length {
                self.stats.record_pass(car);
                false
            } else {
                true
            }
        });
        if self.cars.len() != before {
            self.grid.rebuild(&self.cars);
        }
        self.time += FIXED_DT;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::geometry::Pose;

    #[test]
    fn repeated_spawn_never_overlaps_or_violates_safety_distance() {
        let mut sim = Simulation::new(1);
        assert!(sim.spawn(Route::WestStraight));
        for _ in 0..50 {
            assert!(!sim.spawn(Route::WestStraight));
        }
        sim.advance(2.0);
        assert!(sim.spawn(Route::WestStraight));
        assert_eq!(sim.cars.len(), 2);
        assert!(sim.cars[0].bounds.gap_squared(sim.cars[1].bounds) >= SAFE_DISTANCE.powi(2));
    }

    #[test]
    fn conflicting_left_turn_and_straight_adjust_speed_and_both_finish() {
        let mut sim = Simulation::new(42);
        sim.spawn(Route::WestLeft);
        sim.spawn(Route::EastStraight);
        let mut yielded = false;
        for _ in 0..3600 {
            sim.advance(FIXED_DT);
            for car in &sim.cars {
                let path = &sim.paths[car.route as usize];
                if car.detected_at.is_some()
                    && car.progress < path.entry_distance
                    && car.speed < car.cruise_speed * 0.6
                {
                    yielded = true;
                }
            }
        }
        assert!(yielded);
        assert_eq!(sim.stats.passed, 2);
        assert_eq!(sim.stats.collisions, 0);
        assert_eq!(sim.stats.close_calls, 0);
    }

    #[test]
    fn every_pair_of_routes_completes_without_collision_or_close_call() {
        let mut sim = Simulation::new(7);
        for a in 0..ROUTE_COUNT {
            for b in a + 1..ROUTE_COUNT {
                assert!(sim.spawn(Route::ALL[a]));
                assert!(sim.spawn(Route::ALL[b]));
                for _ in 0..3000 {
                    sim.advance(FIXED_DT);
                    if sim.cars.is_empty() {
                        break;
                    }
                }
                assert!(
                    sim.cars.is_empty(),
                    "routes {:?} and {:?} did not drain",
                    Route::ALL[a],
                    Route::ALL[b]
                );
                assert_eq!(sim.stats.collisions, 0, "pair {a}, {b}");
                assert_eq!(sim.stats.close_calls, 0, "pair {a}, {b}");
            }
        }
        assert_eq!(sim.stats.passed, 132);
    }

    #[test]
    fn rendering_frequency_does_not_change_traffic_or_physics() {
        let run = |fps: usize| {
            let mut sim = Simulation::new(1234);
            sim.auto_spawn = true;
            for _ in 0..fps * 30 {
                sim.advance(1.0 / fps as f64);
            }
            sim
        };
        let baseline = run(60);
        for fps in [30, 144] {
            let other = run(fps);
            assert_eq!(baseline.stats, other.stats);
            assert_eq!(baseline.spawned, other.spawned);
            assert_eq!(baseline.cars.len(), other.cars.len());
            for (a, b) in baseline.cars.iter().zip(&other.cars) {
                assert_eq!(a.route, b.route);
                assert!((a.progress - b.progress).abs() < 0.0001);
            }
        }
    }

    #[test]
    fn pause_does_not_advance_vehicle_timers_or_spawn_traffic() {
        let mut sim = Simulation::new(55);
        sim.spawn(Route::WestStraight);
        sim.advance(4.0);
        assert!(sim.cars[0].detected_at.is_some());
        let elapsed = sim.cars[0].elapsed_time;
        let time = sim.time;
        sim.paused = true;
        sim.auto_spawn = true;
        sim.advance(60.0);
        assert_eq!(sim.time, time);
        assert_eq!(sim.cars[0].elapsed_time, elapsed);
        assert_eq!(sim.spawned, 1);
        sim.paused = false;
        sim.advance(1.0);
        assert!(sim.cars[0].elapsed_time > elapsed);
    }

    #[test]
    fn sustained_mixed_traffic_remains_safe_and_eventually_drains() {
        let mut sim = Simulation::new(2026);
        for step in 0..7200 {
            if step % 5 == 0 {
                let route = sim.random_route();
                sim.spawn(route);
            }
            sim.advance(FIXED_DT);
        }
        for _ in 0..18000 {
            if sim.cars.is_empty() {
                break;
            }
            sim.advance(FIXED_DT);
        }
        assert!(
            sim.spawned >= 200,
            "insufficient stress workload: {} accepted",
            sim.spawned
        );
        assert!(sim.cars.is_empty(), "{} cars stranded", sim.cars.len());
        assert_eq!(sim.stats.passed, sim.spawned);
        assert_eq!(sim.stats.collisions, 0);
        assert_eq!(sim.stats.close_calls, 0);
    }

    #[test]
    fn repeated_close_contact_counts_once_until_pair_separates() {
        let path = Path::for_route(Route::WestStraight);
        let a = Car::new(1, Route::WestStraight, &path, 100.0);
        let mut b = Car::new(2, Route::WestStraight, &path, 100.0);
        b.pose = Pose {
            position: a.pose.position + Vec2::new(CAR_LENGTH + SAFE_DISTANCE - 1.0, 0.0),
            heading: 0.0,
        };
        b.bounds = Bounds::for_pose(b.pose);
        let mut events = SafetyEvents::default();
        let mut stats = Stats::default();
        for _ in 0..60 {
            events.begin();
            events.observe(&a, &b, &mut stats);
            events.finish();
        }
        assert_eq!(stats.close_calls, 1);
        assert_eq!(stats.collisions, 0);
        events.begin();
        events.finish();
        events.begin();
        events.observe(&a, &b, &mut stats);
        events.finish();
        assert_eq!(stats.close_calls, 2);
    }

    #[test]
    fn following_vehicle_stops_at_or_below_the_safety_threshold() {
        let mut sim = Simulation::new(91);
        for gap in [SAFE_DISTANCE, SAFE_DISTANCE - 0.2] {
            sim.cars.clear();
            sim.grid.rebuild(&sim.cars);
            for progress in [220.0, 220.0 - CAR_LENGTH - gap] {
                let path = &sim.paths[Route::WestStraight as usize];
                let mut car = Car::new(sim.next_id, Route::WestStraight, path, 120.0);
                sim.next_id += 1;
                car.progress = progress;
                car.pose = path.pose(progress);
                car.bounds = Bounds::for_pose(car.pose);
                sim.cars.push(car);
            }
            sim.grid.rebuild(&sim.cars);
            let before = sim.cars[1].progress;
            sim.advance(FIXED_DT);
            assert_eq!(sim.cars[1].speed, 0.0);
            assert_eq!(sim.cars[1].progress, before);
        }
    }

    #[test]
    fn one_curved_trip_measures_path_length_and_instantaneous_speed() {
        let mut sim = Simulation::new(18);
        assert!(sim.spawn(Route::WestLeft));
        let cruise = sim.cars[0].cruise_speed;
        let path = &sim.paths[Route::WestLeft as usize];
        let distance = path.length - path.entry_distance + crate::DETECTION_DISTANCE;
        sim.advance(30.0);
        assert_eq!(sim.stats.passed, 1);
        assert!((sim.stats.total_distance - f64::from(distance)).abs() < 0.001);
        assert_eq!(sim.stats.max_speed, Some(cruise));
        assert_eq!(sim.stats.min_speed, Some(0.0));
        assert!((sim.stats.min_time.unwrap() - f64::from(distance / cruise)).abs() < FIXED_DT);
    }

    #[test]
    fn actual_overlap_is_counted_as_one_collision_episode() {
        let path = Path::for_route(Route::WestStraight);
        let a = Car::new(1, Route::WestStraight, &path, 100.0);
        let b = Car::new(2, Route::WestStraight, &path, 100.0);
        let mut events = SafetyEvents::default();
        let mut stats = Stats::default();
        for _ in 0..60 {
            events.begin();
            events.observe(&a, &b, &mut stats);
            events.finish();
        }
        assert_eq!(stats.collisions, 1);
        assert_eq!(stats.close_calls, 1);
    }

    #[test]
    fn fast_follower_slows_for_a_slower_vehicle_without_violating_the_margin() {
        let mut sim = Simulation::new(22);
        sim.spawn(Route::WestStraight);
        sim.cars[0].cruise_speed = 60.0;
        sim.advance(2.0);
        sim.spawn(Route::WestStraight);
        let follower = sim.cars[1].id;
        sim.cars[1].cruise_speed = 120.0;
        let mut fast = false;
        let mut following = false;
        for _ in 0..2400 {
            sim.advance(FIXED_DT);
            if let Some(car) = sim.cars.iter().find(|car| car.id == follower) {
                fast |= car.speed > 80.0;
                following |= car.detected_at.is_some() && car.speed > 0.0 && car.speed <= 65.0;
            }
        }
        assert!(fast && following);
        assert_eq!(sim.stats.passed, 2);
        assert_eq!(sim.stats.collisions, 0);
        assert_eq!(sim.stats.close_calls, 0);
    }

    #[test]
    fn older_conflicting_request_is_served_during_a_continuous_convoy() {
        let mut sim = Simulation::new(63);
        let mut crossing_id = None;
        let mut served = false;
        for step in 0..3600 {
            if step % 30 == 0 {
                sim.spawn(Route::WestStraight);
            }
            if step == 180 {
                assert!(sim.spawn(Route::EastLeft));
                crossing_id = Some(sim.cars.last().unwrap().id);
            }
            sim.advance(FIXED_DT);
            if let Some(id) = crossing_id {
                if !sim.cars.iter().any(|car| car.id == id) {
                    served = true;
                    break;
                }
            }
        }
        assert!(served, "continuous traffic starved the conflicting route");
        assert_eq!(sim.stats.collisions, 0);
        assert_eq!(sim.stats.close_calls, 0);
    }
}
