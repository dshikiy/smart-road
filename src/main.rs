use std::f32::consts::PI;
use std::time::{SystemTime, UNIX_EPOCH};

use macroquad::prelude::*;
use smart_road::{
    route::{Approach, JUNCTION_MAX, JUNCTION_MIN},
    simulation::Simulation,
    CAR_LENGTH, SAFE_DISTANCE, WORLD_SIZE,
};

fn conf() -> Conf {
    Conf {
        window_title: "Smart Road".into(),
        window_width: 1200,
        window_height: 1200,
        window_resizable: true,
        ..Default::default()
    }
}

fn panel(x: f32, y: f32, width: f32, height: f32) {
    draw_rectangle(x, y, width, height, Color::new(0.035, 0.055, 0.075, 0.94));
    draw_rectangle_lines(x, y, width, height, 1.0, Color::new(0.3, 0.5, 0.6, 0.6));
}

fn number(value: Option<f64>, suffix: &str) -> String {
    value.map_or_else(|| "--".into(), |v| format!("{v:.2}{suffix}"))
}

fn row(x: f32, y: f32, width: f32, label: &str, value: &str) {
    draw_text(label, x, y, 20.0, Color::new(0.7, 0.77, 0.8, 1.0));
    let text_width = measure_text(value, None, 20, 1.0).width;
    draw_text(value, x + width - text_width, y, 20.0, WHITE);
}

fn world_camera() {
    let side = screen_width().min(screen_height());
    // This Macroquad version flips screen cameras internally; use positive Y zoom.
    let mut camera = Camera2D {
        target: vec2(WORLD_SIZE * 0.5, WORLD_SIZE * 0.5),
        zoom: vec2(2.0 / WORLD_SIZE, 2.0 / WORLD_SIZE),
        ..Default::default()
    };
    camera.viewport = Some((
        ((screen_width() - side) * 0.5) as i32,
        ((screen_height() - side) * 0.5) as i32,
        side as i32,
        side as i32,
    ));
    set_camera(&camera);
}

fn draw_world(sim: &Simulation, road: &Texture2D, texture: &Texture2D, debug: bool) {
    draw_texture(road, 0.0, 0.0, WHITE);
    if debug {
        draw_rectangle(
            JUNCTION_MIN.x,
            JUNCTION_MIN.y,
            JUNCTION_MAX.x - JUNCTION_MIN.x,
            JUNCTION_MAX.y - JUNCTION_MIN.y,
            Color::new(0.0, 0.6, 0.8, 0.12),
        );
        for path in &sim.paths {
            let mut progress = path.entry_distance;
            while progress < path.exit_distance {
                let next = (progress + 8.0).min(path.exit_distance);
                let a = path.pose(progress).position;
                let b = path.pose(next).position;
                draw_line(a.x, a.y, b.x, b.y, 1.0, Color::new(0.0, 0.7, 0.9, 0.35));
                progress = next;
            }
        }
    }
    let sprite_size = vec2(CAR_LENGTH, CAR_LENGTH * texture.height() / texture.width());
    for car in &sim.cars {
        draw_texture_ex(
            texture,
            car.pose.position.x - sprite_size.x * 0.5,
            car.pose.position.y - sprite_size.y * 0.5,
            WHITE,
            DrawTextureParams {
                dest_size: Some(sprite_size),
                rotation: car.pose.heading - PI,
                ..Default::default()
            },
        );
        if debug {
            let b = car.bounds;
            let color = if car.reserved { SKYBLUE } else { ORANGE };
            draw_rectangle_lines(
                b.min.x,
                b.min.y,
                b.max.x - b.min.x,
                b.max.y - b.min.y,
                1.0,
                color,
            );
            let safe = b.expanded(SAFE_DISTANCE * 0.5);
            draw_rectangle_lines(
                safe.min.x,
                safe.min.y,
                safe.max.x - safe.min.x,
                safe.max.y - safe.min.y,
                1.0,
                Color::new(1.0, 0.85, 0.3, 0.4),
            );
            draw_text(
                &format!("{} {:.0}", car.route.code(), car.speed),
                b.min.x,
                b.min.y - 3.0,
                13.0,
                BLACK,
            );
        }
    }
}

fn draw_hud(sim: &Simulation) {
    panel(12.0, 12.0, 390.0, 280.0);
    draw_text("SMART ROAD", 28.0, 45.0, 28.0, SKYBLUE);
    let rows = [
        (
            "Passed / active",
            format!("{} / {}", sim.stats.passed, sim.cars.len()),
        ),
        (
            "Maximum velocity",
            number(sim.stats.max_speed.map(f64::from), " px/s"),
        ),
        (
            "Minimum velocity",
            number(sim.stats.min_speed.map(f64::from), " px/s"),
        ),
        ("Fastest pass", number(sim.stats.min_time, " s")),
        ("Slowest pass", number(sim.stats.max_time, " s")),
        ("Average pass", number(sim.stats.average_time(), " s")),
        (
            "Simulation / FPS",
            format!("{:.1} s / {}", sim.time, get_fps()),
        ),
    ];
    for (i, (label, value)) in rows.iter().enumerate() {
        row(28.0, 79.0 + i as f32 * 28.0, 358.0, label, value);
    }
    panel(900.0, 12.0, 288.0, 185.0);
    draw_text("INTERSECTION", 916.0, 45.0, 24.0, SKYBLUE);
    row(
        916.0,
        78.0,
        256.0,
        "Collisions",
        &sim.stats.collisions.to_string(),
    );
    row(
        916.0,
        105.0,
        256.0,
        "Close calls",
        &sim.stats.close_calls.to_string(),
    );
    row(
        916.0,
        132.0,
        256.0,
        "Safety distance",
        &format!("{SAFE_DISTANCE:.0} px"),
    );
    row(
        916.0,
        159.0,
        256.0,
        "Auto traffic",
        if sim.auto_spawn { "ON" } else { "OFF" },
    );
    panel(12.0, 1090.0, 420.0, 98.0);
    draw_text(
        "ARROWS: spawn    R: random traffic",
        28.0,
        1120.0,
        20.0,
        WHITE,
    );
    draw_text(
        "P: pause    D: debug    ESC: statistics",
        28.0,
        1148.0,
        20.0,
        WHITE,
    );
    draw_text(
        "Units: pixels, seconds. No traffic lights.",
        28.0,
        1174.0,
        17.0,
        GRAY,
    );
    if sim.paused {
        panel(385.0, 552.0, 430.0, 96.0);
        draw_text("PAUSED", 535.0, 590.0, 30.0, WHITE);
        draw_text("Press P to continue", 480.0, 625.0, 22.0, SKYBLUE);
    }
}

fn draw_summary(sim: &Simulation, road: &Texture2D) {
    draw_texture(road, 0.0, 0.0, Color::new(0.22, 0.22, 0.22, 1.0));
    panel(245.0, 210.0, 710.0, 760.0);
    draw_text("SIMULATION STATISTICS", 290.0, 270.0, 34.0, SKYBLUE);
    let rows = [
        ("Vehicles passed", sim.stats.passed.to_string()),
        ("Vehicles still on map", sim.cars.len().to_string()),
        (
            "Maximum velocity",
            number(sim.stats.max_speed.map(f64::from), " px/s"),
        ),
        (
            "Minimum velocity",
            number(sim.stats.min_speed.map(f64::from), " px/s"),
        ),
        ("Minimum pass time", number(sim.stats.min_time, " s")),
        ("Maximum pass time", number(sim.stats.max_time, " s")),
        ("Average pass time", number(sim.stats.average_time(), " s")),
        ("Collisions", sim.stats.collisions.to_string()),
        ("Close calls", sim.stats.close_calls.to_string()),
        (
            "Prevented movement conflicts",
            sim.stats.prevented_conflicts.to_string(),
        ),
        (
            "Completed travel distance",
            format!("{:.1} px", sim.stats.total_distance),
        ),
        ("Simulation duration", format!("{:.1} s", sim.time)),
    ];
    for (i, (label, value)) in rows.iter().enumerate() {
        row(290.0, 325.0 + i as f32 * 40.0, 620.0, label, value);
    }
    draw_text(
        "ENTER: new simulation     ESC: exit",
        365.0,
        890.0,
        24.0,
        WHITE,
    );
    draw_text(
        "Pass time starts at detection and excludes pauses.",
        310.0,
        932.0,
        20.0,
        GRAY,
    );
}

#[macroquad::main(conf)]
async fn main() {
    let road = Texture2D::from_file_with_format(
        include_bytes!("../assets/cross-road.png"),
        Some(ImageFormat::Png),
    );
    let texture = Texture2D::from_file_with_format(
        include_bytes!("../assets/car.png"),
        Some(ImageFormat::Png),
    );
    road.set_filter(FilterMode::Linear);
    texture.set_filter(FilterMode::Linear);
    let mut seed = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_nanos() as u64;
    let mut sim = Simulation::new(seed);
    let mut debug = false;
    let mut finished = false;

    loop {
        if is_key_pressed(KeyCode::Escape) {
            if finished {
                break;
            }
            finished = true;
        }
        if finished && is_key_pressed(KeyCode::Enter) {
            seed = seed.wrapping_add(1);
            sim = Simulation::new(seed);
            finished = false;
        }
        if !finished {
            if is_key_pressed(KeyCode::P) {
                sim.paused = !sim.paused;
            }
            if is_key_pressed(KeyCode::D) {
                debug = !debug;
            }
            if !sim.paused {
                if is_key_pressed(KeyCode::R) {
                    sim.auto_spawn = !sim.auto_spawn;
                }
                for (key, approach) in [
                    (KeyCode::Up, Approach::South),
                    (KeyCode::Down, Approach::North),
                    (KeyCode::Right, Approach::West),
                    (KeyCode::Left, Approach::East),
                ] {
                    if is_key_pressed(key) {
                        sim.spawn_from(approach);
                    }
                }
            }
            sim.advance(f64::from(get_frame_time().min(0.25)));
        }
        clear_background(Color::new(0.02, 0.03, 0.04, 1.0));
        world_camera();
        if finished {
            draw_summary(&sim, &road);
        } else {
            draw_world(&sim, &road, &texture, debug);
            draw_hud(&sim);
        }
        set_default_camera();
        next_frame().await;
    }
}
