use crate::{
    geometry::{velocity, Bounds, Pose},
    route::{Path, Route},
    ACCELERATION, BRAKING, DETECTION_DISTANCE,
};

#[derive(Debug)]
pub struct Car {
    pub id: u64,
    pub route: Route,
    pub progress: f32,
    pub pose: Pose,
    pub bounds: Bounds,
    pub speed: f32,
    pub cruise_speed: f32,
    pub distance: f32,
    pub elapsed_time: f64,
    pub detected_at: Option<f64>,
    pub reserved: bool,
    pub min_speed: f32,
    pub max_speed: f32,
    pub(crate) was_blocked: bool,
}

impl Car {
    pub fn new(id: u64, route: Route, path: &Path, cruise_speed: f32) -> Self {
        let pose = path.pose(0.0);
        Self {
            id,
            route,
            progress: 0.0,
            pose,
            bounds: Bounds::for_pose(pose),
            speed: 0.0,
            cruise_speed,
            distance: 0.0,
            elapsed_time: 0.0,
            detected_at: None,
            reserved: false,
            min_speed: 0.0,
            max_speed: 0.0,
            was_blocked: false,
        }
    }

    pub fn average_speed(&self) -> Option<f32> {
        velocity(self.distance, self.elapsed_time)
    }

    /// Four regimes, plus a braking-distance cap. Units are pixels and seconds.
    pub fn target_speed(&self, clearance: f32) -> f32 {
        if clearance <= 0.001 {
            return 0.0;
        }
        let ratio = if clearance <= 25.0 {
            0.25
        } else if clearance <= 65.0 {
            0.5
        } else {
            1.0
        };
        (self.cruise_speed * ratio).min((2.0 * BRAKING * clearance).sqrt())
    }

    pub fn integrate(&self, target: f32, dt: f32) -> (f32, f32) {
        let rate = if target > self.speed {
            ACCELERATION
        } else {
            BRAKING
        };
        let next = self.speed + (target - self.speed).clamp(-rate * dt, rate * dt);
        (next, (self.speed + next) * 0.5 * dt)
    }

    pub(crate) fn advance(&mut self, path: &Path, distance: f32, speed: f32, time: f64, dt: f64) {
        let old = self.progress;
        self.progress = (old + distance).min(path.length);
        self.pose = path.pose(self.progress);
        self.bounds = Bounds::for_pose(self.pose);
        self.speed = speed;
        self.min_speed = self.min_speed.min(speed);
        self.max_speed = self.max_speed.max(speed);
        let detection = path.entry_distance - DETECTION_DISTANCE;
        if self.detected_at.is_none() && self.progress >= detection {
            let fraction = if distance > 0.0 {
                ((detection - old) / distance).clamp(0.0, 1.0)
            } else {
                0.0
            };
            self.detected_at = Some(time + dt * f64::from(fraction));
        }
        if let Some(detected) = self.detected_at {
            let finish_fraction = if distance > 0.0 {
                ((path.length - old) / distance).min(1.0)
            } else {
                1.0
            };
            self.elapsed_time = (time + dt * f64::from(finish_fraction) - detected).max(0.0);
            self.distance = (self.progress - detection).max(0.0);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn motion_integrates_acceleration_and_preserves_three_moving_speed_regimes() {
        let path = Path::for_route(Route::WestStraight);
        let mut car = Car::new(1, Route::WestStraight, &path, 120.0);
        assert_eq!(car.target_speed(20.0), 30.0);
        assert_eq!(car.target_speed(60.0), 60.0);
        assert_eq!(car.target_speed(200.0), 120.0);
        assert_eq!(car.target_speed(0.0), 0.0);
        let (speed, distance) = car.integrate(120.0, 0.5);
        assert_eq!(speed, 37.5);
        assert_eq!(distance, 9.375);
        car.speed = 120.0;
        assert_eq!(car.integrate(0.0, 0.5), (30.0, 37.5));
    }

    #[test]
    fn curved_distance_is_arc_length_and_detection_starts_the_timer() {
        let path = Path::for_route(Route::WestLeft);
        let mut car = Car::new(1, Route::WestLeft, &path, 120.0);
        let detection = path.entry_distance - DETECTION_DISTANCE;
        car.advance(&path, detection + 10.0, 100.0, 0.0, 4.0);
        assert!((car.distance - 10.0).abs() < 0.001);
        assert!(car.elapsed_time < 4.0);
        car.advance(&path, path.length, 100.0, 4.0, 20.0);
        assert!((car.distance - (path.length - detection)).abs() < 0.001);
        assert!(car.average_speed().unwrap() > 0.0);
    }
}
