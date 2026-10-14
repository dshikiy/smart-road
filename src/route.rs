use std::f32::consts::{FRAC_PI_2, PI};

use macroquad::math::{vec2, Vec2};

use crate::{geometry::Pose, CAR_LENGTH, SAFE_DISTANCE};

pub const ROUTE_COUNT: usize = 12;
pub const JUNCTION_MIN: Vec2 = vec2(450.0, 465.0);
pub const JUNCTION_MAX: Vec2 = vec2(750.0, 760.0);
const OFFSCREEN: f32 = 30.0;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Approach {
    West,
    East,
    North,
    South,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[repr(usize)]
pub enum Route {
    WestRight,
    WestStraight,
    WestLeft,
    EastRight,
    EastStraight,
    EastLeft,
    NorthRight,
    NorthStraight,
    NorthLeft,
    SouthRight,
    SouthStraight,
    SouthLeft,
}

impl Route {
    pub const ALL: [Self; ROUTE_COUNT] = [
        Self::WestRight,
        Self::WestStraight,
        Self::WestLeft,
        Self::EastRight,
        Self::EastStraight,
        Self::EastLeft,
        Self::NorthRight,
        Self::NorthStraight,
        Self::NorthLeft,
        Self::SouthRight,
        Self::SouthStraight,
        Self::SouthLeft,
    ];

    pub fn from_approach(approach: Approach, choice: usize) -> Self {
        let offset = match approach {
            Approach::West => 0,
            Approach::East => 3,
            Approach::North => 6,
            Approach::South => 9,
        };
        Self::ALL[offset + choice % 3]
    }

    pub fn approach(self) -> Approach {
        match self as usize / 3 {
            0 => Approach::West,
            1 => Approach::East,
            2 => Approach::North,
            _ => Approach::South,
        }
    }

    pub fn code(self) -> &'static str {
        match self {
            Self::WestRight => "LD",
            Self::WestStraight => "LR",
            Self::WestLeft => "LU",
            Self::EastRight => "RU",
            Self::EastStraight => "RL",
            Self::EastLeft => "RD",
            Self::NorthRight => "UL",
            Self::NorthStraight => "UD",
            Self::NorthLeft => "UR",
            Self::SouthRight => "DR",
            Self::SouthStraight => "DU",
            Self::SouthLeft => "DL",
        }
    }
}

#[derive(Clone, Copy, Debug)]
enum Segment {
    Line {
        from: Vec2,
        to: Vec2,
    },
    Arc {
        center: Vec2,
        radius: f32,
        start: f32,
        sweep: f32,
    },
}

impl Segment {
    fn length(self) -> f32 {
        match self {
            Self::Line { from, to } => from.distance(to),
            Self::Arc { radius, sweep, .. } => radius * sweep.abs(),
        }
    }

    fn pose(self, distance: f32) -> Pose {
        let t = (distance / self.length()).clamp(0.0, 1.0);
        match self {
            Self::Line { from, to } => Pose {
                position: from.lerp(to, t),
                heading: (to.y - from.y).atan2(to.x - from.x),
            },
            Self::Arc {
                center,
                radius,
                start,
                sweep,
            } => {
                let angle = start + sweep * t;
                Pose {
                    position: center + vec2(angle.cos(), angle.sin()) * radius,
                    heading: angle + sweep.signum() * FRAC_PI_2,
                }
            }
        }
    }
}

#[derive(Clone, Debug)]
pub struct Path {
    segments: Vec<Segment>,
    pub length: f32,
    pub entry_distance: f32,
    pub exit_distance: f32,
}

impl Path {
    pub fn for_route(route: Route) -> Self {
        use Route::*;
        let edge = 1200.0 + OFFSCREEN;
        let straight = |from, to| vec![Segment::Line { from, to }];
        let turn = |from, center, radius, start, sweep, to| {
            let arc = Segment::Arc {
                center,
                radius,
                start,
                sweep,
            };
            vec![
                Segment::Line {
                    from,
                    to: arc.pose(0.0).position,
                },
                arc,
                Segment::Line {
                    from: arc.pose(arc.length()).position,
                    to,
                },
            ]
        };
        let segments = match route {
            WestStraight => straight(vec2(-OFFSCREEN, 671.5), vec2(edge, 671.5)),
            EastStraight => straight(vec2(edge, 551.5), vec2(-OFFSCREEN, 551.5)),
            NorthStraight => straight(vec2(532.5, -OFFSCREEN), vec2(532.5, edge)),
            SouthStraight => straight(vec2(659.5, edge), vec2(659.5, -OFFSCREEN)),
            WestRight => turn(
                vec2(-OFFSCREEN, 711.5),
                vec2(471.5, 733.5),
                22.0,
                -FRAC_PI_2,
                FRAC_PI_2,
                vec2(493.5, edge),
            ),
            WestLeft => turn(
                vec2(-OFFSCREEN, 633.5),
                vec2(534.5, 548.5),
                85.0,
                FRAC_PI_2,
                -FRAC_PI_2,
                vec2(619.5, -OFFSCREEN),
            ),
            EastRight => turn(
                vec2(edge, 511.5),
                vec2(721.5, 489.5),
                22.0,
                FRAC_PI_2,
                FRAC_PI_2,
                vec2(699.5, -OFFSCREEN),
            ),
            EastLeft => turn(
                vec2(edge, 590.5),
                vec2(659.5, 675.5),
                85.0,
                -FRAC_PI_2,
                -FRAC_PI_2,
                vec2(574.5, edge),
            ),
            NorthRight => turn(
                vec2(493.5, -OFFSCREEN),
                vec2(471.5, 489.5),
                22.0,
                0.0,
                FRAC_PI_2,
                vec2(-OFFSCREEN, 511.5),
            ),
            NorthLeft => turn(
                vec2(574.5, -OFFSCREEN),
                vec2(659.5, 548.5),
                85.0,
                PI,
                -FRAC_PI_2,
                vec2(edge, 633.5),
            ),
            SouthRight => turn(
                vec2(699.5, edge),
                vec2(721.5, 733.5),
                22.0,
                PI,
                FRAC_PI_2,
                vec2(edge, 711.5),
            ),
            SouthLeft => turn(
                vec2(619.5, edge),
                vec2(534.5, 675.5),
                85.0,
                0.0,
                -FRAC_PI_2,
                vec2(-OFFSCREEN, 590.5),
            ),
        };
        let length = segments.iter().map(|s| s.length()).sum();
        let padding = CAR_LENGTH * 0.5 + SAFE_DISTANCE + 0.1;
        let entry_distance = match route.approach() {
            Approach::West => JUNCTION_MIN.x - padding + OFFSCREEN,
            Approach::East => edge - JUNCTION_MAX.x - padding,
            Approach::North => JUNCTION_MIN.y - padding + OFFSCREEN,
            Approach::South => edge - JUNCTION_MAX.y - padding,
        };
        let end = segments
            .last()
            .unwrap()
            .pose(segments.last().unwrap().length())
            .position;
        let outside = if end.x < 0.0 {
            JUNCTION_MIN.x - padding + OFFSCREEN
        } else if end.x > 1200.0 {
            edge - JUNCTION_MAX.x - padding
        } else if end.y < 0.0 {
            JUNCTION_MIN.y - padding + OFFSCREEN
        } else {
            edge - JUNCTION_MAX.y - padding
        };
        Self {
            segments,
            length,
            entry_distance,
            exit_distance: length - outside,
        }
    }

    pub fn pose(&self, mut distance: f32) -> Pose {
        distance = distance.clamp(0.0, self.length);
        for &segment in &self.segments {
            if distance <= segment.length() {
                return segment.pose(distance);
            }
            distance -= segment.length();
        }
        let last = *self.segments.last().unwrap();
        last.pose(last.length())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn all_twelve_routes_are_continuous_and_finish_outside_canvas() {
        for route in Route::ALL {
            let path = Path::for_route(route);
            assert!(path.entry_distance < path.exit_distance && path.exit_distance < path.length);
            let end = path.pose(path.length).position;
            assert!(end.x < 0.0 || end.x > 1200.0 || end.y < 0.0 || end.y > 1200.0);
            let mut previous = path.pose(0.0);
            for step in 1..=(path.length.ceil() as usize) {
                let pose = path.pose(step as f32);
                assert!(
                    previous.position.distance(pose.position) <= 1.01,
                    "{:?}: discontinuous path",
                    route
                );
                let turn = (pose.heading - previous.heading)
                    .sin()
                    .atan2((pose.heading - previous.heading).cos());
                assert!(turn.abs() < 0.05, "{:?}: discontinuous rotation", route);
                previous = pose;
            }
        }
    }
}
