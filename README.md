
# Smart Road

A traffic control system for cars entering an intersection application written in Rust

Current graphics: matte graphite Porsche 991 sprites and a city map with multi-storey buildings.
The simulation uses a fixed physics timestep, corridor reservations and spatial collision queries.



## Instructions

#### **Intersection**

There are various shapes of intersections, we will focus on the widely seen cross intersection, where each lane has a different route:

- `r`, turning right
- `s`, straight ahead
- `l`, turning left

```console
               |   |   |   |   |   |   |
               |   |   |   |   |   |   |
               |   |   |   |   |   |   |
               |r  | s | l |   |   |   |
_______________| ← | ↓ | → |   |   |   |________________
                           |            ↑ r
_______________            |            ________________
                           |            ← s
_______________            |            ________________
                           |            ↓ l
___________________________|____________________________
           l ↑             |
_______________            |            ________________
           s →             |
_______________            |            ________________
           r ↓             |
_______________            |            ________________
               |   |   |   | ← | ↑ | → |
               |   |   |   | l | s | r |
               |   |   |   |   |   |   |
               |   |   |   |   |   |   |
               |   |   |   |   |   |   |
               |   |   |   |   |   |   |
```

---

#### **Vehicles**

```console
  ______
 /|_||_\`.__
=`-(_)--(_)-'
```
1. AVs driving on a lane with a **given route** must follow the direction of that route; the AVs can't change lanes or routes.

2. AVs must have at least 3 different velocities. Therefore the **smart intersection system** can control the velocity of the vehicle.\
   This will be the way of controlling the current velocity/time/distance (depending on the algorithm you implement) of the AVs.

3. Each AV must respect a safety distance from other AVs.\
   If a vehicle is driving at a high velocity and encounters another vehicle, it must detect that vehicle and keep a safe distance from it. It should not collide!
   You are free to decide the safety distance, but it must be a strictly positive value.

4. Other vehicles, such as emergency vehicles, are not considered in this project.

5. You must implement physics for the vehicle, such as `velocity = distance / time`. Each vehicle must have a :

- `time`: the time that the AV takes to leave the intersection
- `distance`: the distance that the AV takes to leave the intersection
- `velocity`: the speed of the AV at the current time

#### **Commands**

1. The creation of vehicles must be done using the keyboard events
- `Arrow Up`, generate vehicles from south to north.
- `Arrow Down`, generate vehicles from north to south.
- `Arrow Right`, generate vehicles from west to east.
- `Arrow Left`, generate vehicles from east to west.

2. It must also be possible to use the key `R` to continually generate random vehicles (using the game loop).

3. The `Esc` key must finish the simulation and generate a window with all statistics

4. When spamming the same key, the vehicles should not be generated all at the same time. In other words, the vehicles should not be created on top of each other.

---

#### **Statistics**

The statistics must include:

- Max number of vehicles that passed the intersection
- Max velocity of all vehicles (Display the fastest speed achieved)
- Min velocity of all vehicles (Display the slowest speed reached)
- Max time that the vehicles took to pass the intersection (for all vehicles, display the one that took more time)
- Min time that the vehicles took to pass the intersection (for all vehicles, display the one that took less time)
    - The time starts to count whenever the vehicle is detected by the **smart intersection algorithm** until the end of the intersection, which is when the vehicle is removed from the canvas.
- Close calls, this is when both vehicles pass each other with a violation of the safe distance.
## Authors

- Cenk
- Jimmy
- Acki


## Run Locally

Clone the project

```bash
  git clone https://01.gritlab.ax/git/minhtuann/smart-road
```

Go to the project directory

```bash
  cd smart-road
```

Start the app from the project root (Rust 1.75 or newer)

```bash
  cargo run --release
```

## Implementation and audit

### Controls

| Key | Action |
| --- | --- |
| Up / Down | Spawn from the south / north |
| Right / Left | Spawn from the west / east |
| R | Toggle random traffic: one spawn attempt per simulation second |
| P | Pause / resume; simulation timers and traffic generation also pause |
| D | Toggle paths, body bounds, safety margins and vehicle speeds |
| Esc | Freeze the simulation and show all statistics; press again to exit |
| Enter on the statistics screen | Start a new simulation |

Each arrow selects the incoming direction. One of that direction's three fixed routes
is chosen randomly. A route never changes after spawning. Repeated key presses are
accepted only when the spawn area has enough free space.

### Physics and intersection management

* World coordinates are pixels; time is seconds; velocity is pixels/second.
* Physics and automatic arrivals advance at a fixed 1/60 second step, independently of rendering FPS.
* Vehicle bodies are 43 by 28 pixels. The strictly positive safety distance is **6 pixels**
  between conservative axis-aligned bounds of the rotated bodies.
* Each of the twelve routes has a fixed incoming lane, outgoing lane and geometric path.
  Turns are quarter circles, with continuous position and sprite rotation.
* Acceleration is 75 px/s² and normal braking is 180 px/s². Vehicles have stopped,
  quarter-speed, half-speed and cruise regimes, plus continuous following control.
  Cruise speeds vary from 90 to just below 120 px/s. A final motion guard can brake
  more strongly when necessary to preserve the safety distance.
* The manager detects a vehicle 160 pixels before its stop line. Near the stop line it
  requests a route reservation. Conflicting routes cannot hold reservations together;
  geometrically compatible routes can pass concurrently. No traffic lights are used.
* Conflict corridors are precomputed once from swept vehicle bounds along each route.
  Reservations cover the whole crossing and are released after the entire body clears it.
* Requests are ordered by detection time. Convoys of at most three vehicles improve flow;
  a convoy cannot be extended indefinitely ahead of an older conflicting request.
* A spatial hash with 64-pixel cells checks nearby vehicles. Following checks use vehicles
  ordered within each route. The update loop does not clone the complete vehicle list.
* A swept-bounds guard checks every movement, including turns, before committing it.
  There is a limit of 1024 active vehicles; occupied spawn areas reject new attempts.

### Statistics definitions

* **Vehicles passed:** cumulative number of completed routes, with the car fully outside
  the 1200×1200 canvas. Cars still on the map are displayed separately.
* **Maximum/minimum velocity:** extrema of instantaneous speeds observed for all cars,
  including a real zero while stationary. These are not average trip speeds.
* **Minimum/maximum pass time:** simulation time from detection to leaving the canvas.
  Pauses are excluded. Only completed trips contribute to these time extrema.
* **Distance:** actual distance along the route, including circular arc length, from
  detection to completion. Average trip velocity is distance divided by elapsed time.
* **Close calls:** distinct episodes in which a pair violates the 6-pixel margin.
  A persistent violation counts once until the pair separates.
* **Collisions:** distinct episodes of overlapping vehicle bounds, also counted once
  until separation. A collision also violates the safety distance.
* **Prevented movement conflicts:** separate diagnostic for motion-guard interventions;
  an avoided collision is not falsely reported as an actual close call.
* Missing values display as `--`, rather than sentinel numbers.

### Reproducible checks

```bash
cargo test --locked --all-targets
cargo build --release --locked
cargo run --release --bin audit -- --seconds 120 --rate 12 --seed 2026 --drain 300
```

The `audit` binary runs without opening a window or loading assets. It generates a
repeatable stream, stops arrivals and lets the existing queue drain. It prints accepted
and rejected spawn attempts, completed passes, remaining cars, safety events, neighbor
checks and execution time. Exit status is nonzero if cars remain, a safety violation
occurs, no cars were admitted, or the arguments are invalid. Use `--help` for options.
Rejected attempts are not silently queued or included in the passed count.

Unit and simulation tests cover:

| Mandatory audit category | Coverage |
| --- | --- |
| Physics | Distance/time at several speeds; acceleration and braking; actual curved path length |
| Safety distance | Equal/below-threshold stopping; repeated spawn rejection; positive detection of violations |
| Smart intersection | Conflicting left turn and straight; compatible opposite straights; all 66 distinct route pairs |
| Statistics | Count, speed/time extrema, distance accumulation and unique event episodes |
| Additional regressions | Pause timing, 30/60/144 FPS equivalence, continuous turns and sustained mixed traffic draining |

Validation on Rust 1.75 (12 October 2026): **20 tests passed**, including faster-follower
braking and service of an older conflicting request during continuous traffic. Release
build, Rustfmt and Clippy with warnings denied passed. A headless matrix using seeds
1 through 20, 120 seconds of arrivals at 12 attempts/second and up to 300 seconds to
drain completed **4857 admitted vehicles**, with zero collisions, zero close calls and
zero remaining cars. Separate 1 and 60 attempts/second runs also drained safely.
Admission rejections under overload are reported explicitly by the command above.

When Rustfmt and Clippy are installed, also run:

```bash
cargo fmt --all -- --check
cargo clippy --all-targets --locked -- -D warnings
```

### Code layout

* `src/main.rs`: keyboard input, rendering, HUD and final statistics.
* `src/car.rs`: vehicle state, acceleration, speed control, distance and elapsed time.
* `src/route.rs`: typed routes and analytic line/arc paths.
* `src/intersection.rs`: precomputed corridor conflict matrix.
* `src/simulation.rs`: fixed-step clock, reservations, following, spatial grid and safety monitoring.
* `src/stats.rs`: statistics accumulation, independent of the graphics context.
* `src/bin/audit.rs`: deterministic headless stress check.

The existing city and Porsche assets are embedded at compile time, so the executable
can run from another directory. Rebuild after changing a texture. Assets remain in
`assets/` for editing; tests and headless audits do not need a display.

### Scope and limits

The simulation models one fixed intersection. Its collision bounds and reservations
are intentionally conservative. It does not claim mathematically optimal throughput:
heavy offered traffic can fill the entry lanes and cause spawn rejections. The stress
check verifies safety and eventual drainage for its supplied seed, duration and rate;
it is not an exhaustive proof for every possible input. Road positions are fixed to
the supplied map. The GUI caps one received frame interval at 0.25 seconds to avoid
an excessive catch-up after a stalled window; simulation timers measure simulated time.



