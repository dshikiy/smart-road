use crate::{
    geometry::Bounds,
    route::{Path, Route, ROUTE_COUNT},
    SAFE_DISTANCE,
};

/// Reserves entire conflicting corridors, with parallel access to compatible routes.
/// Following vehicles on the same route are spaced separately by the motion engine.
pub struct Intersection {
    conflicts: [u16; ROUTE_COUNT],
}

impl Intersection {
    pub fn new(paths: &[Path; ROUTE_COUNT]) -> Self {
        let corridors: [Vec<Bounds>; ROUTE_COUNT] = std::array::from_fn(|index| {
            let path = &paths[index];
            let mut result = Vec::new();
            let mut distance = path.entry_distance;
            while distance < path.exit_distance {
                let next = (distance + 2.0).min(path.exit_distance);
                // The union covers each 2px interval; 0.1px covers curvature between samples.
                result.push(
                    Bounds::for_pose(path.pose(distance))
                        .union(Bounds::for_pose(path.pose(next)))
                        .expanded(0.1),
                );
                distance = next;
            }
            result
        });
        let mut conflicts = [0; ROUTE_COUNT];
        for a in 0..ROUTE_COUNT {
            for b in a + 1..ROUTE_COUNT {
                if corridors[a].iter().any(|left| {
                    corridors[b]
                        .iter()
                        .any(|right| left.gap_squared(*right) <= SAFE_DISTANCE * SAFE_DISTANCE)
                }) {
                    conflicts[a] |= 1 << b;
                    conflicts[b] |= 1 << a;
                }
            }
        }
        Self { conflicts }
    }

    pub fn can_reserve(&self, route: Route, occupied: u16) -> bool {
        self.conflicts[route as usize] & occupied == 0
    }

    pub fn routes_conflict(&self, a: Route, b: Route) -> bool {
        self.conflicts[a as usize] & (1 << b as usize) != 0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn crossing_left_turn_waits_but_opposite_straights_can_share_intersection() {
        let paths = std::array::from_fn(|i| Path::for_route(Route::ALL[i]));
        let manager = Intersection::new(&paths);
        assert!(manager.routes_conflict(Route::WestLeft, Route::EastStraight));
        assert!(!manager.can_reserve(Route::WestLeft, 1 << Route::EastStraight as usize));
        assert!(!manager.routes_conflict(Route::WestStraight, Route::EastStraight));
        assert!(manager.can_reserve(Route::WestStraight, 1 << Route::EastStraight as usize));
    }
}
