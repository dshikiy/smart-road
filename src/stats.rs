use crate::car::Car;

#[derive(Debug, Default, PartialEq)]
pub struct Stats {
    pub passed: u64,
    pub min_speed: Option<f32>,
    pub max_speed: Option<f32>,
    pub min_time: Option<f64>,
    pub max_time: Option<f64>,
    pub total_distance: f64,
    pub total_time: f64,
    pub close_calls: u64,
    pub collisions: u64,
    pub prevented_conflicts: u64,
}

impl Stats {
    pub fn observe_speed(&mut self, speed: f32) {
        if speed.is_finite() && speed >= 0.0 {
            self.min_speed = Some(self.min_speed.map_or(speed, |old| old.min(speed)));
            self.max_speed = Some(self.max_speed.map_or(speed, |old| old.max(speed)));
        }
    }

    pub fn record_pass(&mut self, car: &Car) {
        self.passed += 1;
        self.observe_speed(car.min_speed);
        self.observe_speed(car.max_speed);
        self.min_time = Some(
            self.min_time
                .map_or(car.elapsed_time, |old| old.min(car.elapsed_time)),
        );
        self.max_time = Some(
            self.max_time
                .map_or(car.elapsed_time, |old| old.max(car.elapsed_time)),
        );
        self.total_distance += f64::from(car.distance);
        self.total_time += car.elapsed_time;
    }

    pub fn average_time(&self) -> Option<f64> {
        (self.passed > 0).then(|| self.total_time / self.passed as f64)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::route::{Path, Route};

    #[test]
    fn completed_passes_accumulate_counts_extrema_and_actual_distance() {
        let path = Path::for_route(Route::WestStraight);
        let mut stats = Stats::default();
        assert_eq!(stats.min_time, None);
        assert_eq!(stats.max_speed, None);
        for (time, distance, min_speed, max_speed) in
            [(12.0, 900.0, 0.0, 120.0), (9.0, 810.0, 30.0, 100.0)]
        {
            let mut car = Car::new(1, Route::WestStraight, &path, 120.0);
            car.elapsed_time = time;
            car.distance = distance;
            car.min_speed = min_speed;
            car.max_speed = max_speed;
            stats.record_pass(&car);
        }
        assert_eq!(stats.passed, 2);
        assert_eq!(stats.min_speed, Some(0.0));
        assert_eq!(stats.max_speed, Some(120.0));
        assert_eq!(stats.min_time, Some(9.0));
        assert_eq!(stats.max_time, Some(12.0));
        assert_eq!(stats.total_distance, 1710.0);
        assert_eq!(stats.average_time(), Some(10.5));
    }
}
