use macroquad::math::{vec2, Vec2};

use crate::{CAR_LENGTH, CAR_WIDTH, SAFE_DISTANCE};

#[derive(Clone, Copy, Debug)]
pub struct Pose {
    pub position: Vec2,
    /// Radians: east = 0, south = PI / 2 (screen coordinates).
    pub heading: f32,
}

#[derive(Clone, Copy, Debug)]
pub struct Bounds {
    pub min: Vec2,
    pub max: Vec2,
}

impl Bounds {
    pub fn for_pose(pose: Pose) -> Self {
        let (sin, cos) = pose.heading.sin_cos();
        let half = vec2(
            cos.abs() * CAR_LENGTH + sin.abs() * CAR_WIDTH,
            sin.abs() * CAR_LENGTH + cos.abs() * CAR_WIDTH,
        ) * 0.5;
        Self {
            min: pose.position - half,
            max: pose.position + half,
        }
    }

    pub fn expanded(self, margin: f32) -> Self {
        Self {
            min: self.min - Vec2::splat(margin),
            max: self.max + Vec2::splat(margin),
        }
    }

    pub fn union(self, other: Self) -> Self {
        Self {
            min: self.min.min(other.min),
            max: self.max.max(other.max),
        }
    }

    pub fn gap_squared(self, other: Self) -> f32 {
        let delta = (self.min - other.max)
            .max(other.min - self.max)
            .max(Vec2::ZERO);
        delta.length_squared()
    }

    pub fn overlaps(self, other: Self) -> bool {
        self.min.x < other.max.x
            && other.min.x < self.max.x
            && self.min.y < other.max.y
            && other.min.y < self.max.y
    }
}

pub fn requires_stop(gap: f32) -> bool {
    gap <= SAFE_DISTANCE
}

pub fn velocity(distance: f32, seconds: f64) -> Option<f32> {
    if distance.is_finite() && distance >= 0.0 && seconds.is_finite() && seconds > 0.0 {
        Some((f64::from(distance) / seconds) as f32)
    } else {
        None
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn velocity_uses_actual_distance_and_elapsed_seconds() {
        for (distance, time, expected) in [(120.0, 2.0, 60.0), (90.0, 0.5, 180.0), (0.0, 3.0, 0.0)]
        {
            assert_eq!(velocity(distance, time), Some(expected));
        }
        assert_eq!(velocity(1.0, 0.0), None);
        assert_eq!(velocity(-1.0, 1.0), None);
        assert_eq!(velocity(1.0, f64::NAN), None);
    }

    #[test]
    fn stop_threshold_includes_equal_safety_distance() {
        assert!(requires_stop(SAFE_DISTANCE));
        assert!(requires_stop(SAFE_DISTANCE - 0.1));
        assert!(!requires_stop(SAFE_DISTANCE + 0.1));
    }

    #[test]
    fn distance_between_bounds_handles_diagonal_neighbors() {
        let a = Bounds {
            min: vec2(0.0, 0.0),
            max: vec2(10.0, 10.0),
        };
        let b = Bounds {
            min: vec2(13.0, 14.0),
            max: vec2(20.0, 20.0),
        };
        assert_eq!(a.gap_squared(b), 25.0);
        assert!(!a.overlaps(b));
        assert!(a.overlaps(a));
    }
}
