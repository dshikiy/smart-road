pub mod car;
pub mod geometry;
pub mod intersection;
pub mod route;
pub mod simulation;
pub mod stats;

pub const WORLD_SIZE: f32 = 1200.0;
pub const CAR_LENGTH: f32 = 43.0;
pub const CAR_WIDTH: f32 = 28.0;
pub const SAFE_DISTANCE: f32 = 6.0;
pub const FIXED_DT: f64 = 1.0 / 60.0;
pub const DETECTION_DISTANCE: f32 = 160.0;
pub const ACCELERATION: f32 = 75.0;
pub const BRAKING: f32 = 180.0;
