use std::process::ExitCode;
use std::time::Instant;

use smart_road::{simulation::Simulation, FIXED_DT};

fn parameter<T: std::str::FromStr>(args: &[String], name: &str, default: T) -> Result<T, String> {
    match args.iter().position(|arg| arg == name) {
        Some(index) => args
            .get(index + 1)
            .ok_or_else(|| format!("missing value for {name}"))?
            .parse()
            .map_err(|_| format!("invalid value for {name}")),
        None => Ok(default),
    }
}

fn run() -> Result<bool, String> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.iter().any(|arg| arg == "--help") {
        println!("Headless audit: --seconds 120 --rate 12 --seed 2026 --drain 300");
        println!("All durations are simulation seconds; rate is attempted vehicles/second.");
        return Ok(true);
    }
    for argument in args.iter().step_by(2) {
        if !["--seconds", "--rate", "--seed", "--drain"].contains(&argument.as_str()) {
            return Err(format!("unknown option: {argument}"));
        }
    }
    let seconds: f64 = parameter(&args, "--seconds", 120.0)?;
    let rate: f64 = parameter(&args, "--rate", 12.0)?;
    let seed: u64 = parameter(&args, "--seed", 2026)?;
    let drain: f64 = parameter(&args, "--drain", 300.0)?;
    if !seconds.is_finite()
        || !(0.0..=3600.0).contains(&seconds)
        || seconds == 0.0
        || !rate.is_finite()
        || !(0.0..=60.0).contains(&rate)
        || rate == 0.0
        || !drain.is_finite()
        || !(0.0..=3600.0).contains(&drain)
    {
        return Err("seconds must be in (0, 3600], rate in (0, 60], drain in [0, 3600]".into());
    }
    let start = Instant::now();
    let mut sim = Simulation::new(seed);
    let mut spawn_clock = 0.0;
    let mut peak = 0;
    for _ in 0..(seconds / FIXED_DT).ceil() as usize {
        spawn_clock += FIXED_DT;
        while spawn_clock + 1e-9 >= 1.0 / rate {
            spawn_clock -= 1.0 / rate;
            let route = sim.random_route();
            sim.spawn(route);
        }
        sim.advance(FIXED_DT);
        peak = peak.max(sim.cars.len());
    }
    let passed_under_load = sim.stats.passed;
    for _ in 0..(drain / FIXED_DT).ceil() as usize {
        if sim.cars.is_empty() {
            break;
        }
        sim.advance(FIXED_DT);
    }
    println!("seed={seed} traffic_seconds={seconds} attempted_rate={rate}");
    println!(
        "attempts={} accepted={} rejected={} peak_active={peak}",
        sim.spawn_attempts,
        sim.spawned,
        sim.spawn_attempts - sim.spawned
    );
    println!(
        "passed_under_load={passed_under_load} passed_total={} remaining={}",
        sim.stats.passed,
        sim.cars.len()
    );
    println!(
        "collisions={} close_calls={} prevented_conflicts={}",
        sim.stats.collisions, sim.stats.close_calls, sim.stats.prevented_conflicts
    );
    println!(
        "min_speed={:?} max_speed={:?} min_time={:?} max_time={:?}",
        sim.stats.min_speed, sim.stats.max_speed, sim.stats.min_time, sim.stats.max_time
    );
    println!(
        "neighbor_checks={} simulation_seconds={:.2} wall_seconds={:.3}",
        sim.neighbor_checks,
        sim.time,
        start.elapsed().as_secs_f64()
    );
    let passed = sim.stats.collisions == 0
        && sim.stats.close_calls == 0
        && sim.cars.is_empty()
        && sim.stats.passed == sim.spawned
        && sim.spawned > 0;
    println!("audit={}", if passed { "PASS" } else { "FAIL" });
    Ok(passed)
}

fn main() -> ExitCode {
    match run() {
        Ok(true) => ExitCode::SUCCESS,
        Ok(false) => ExitCode::FAILURE,
        Err(message) => {
            eprintln!("{message}");
            ExitCode::from(2)
        }
    }
}
