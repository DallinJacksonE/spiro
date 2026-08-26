package scenes

import drones "../assets/drones"
import map_tools "../assets/map_tools"
import states "../states"
import "core:math"
import rl "vendor:raylib"

FIELD_TILE_SIZE :: f32(1.6)
FIELD_MAP_WIDTH :: 12
FIELD_MAP_HEIGHT :: 10
DRONE_LAUNCH_HEIGHT :: f32(1.1)
DRONE_MOVE_SPEED :: f32(5.2)
DRONE_VERTICAL_SPEED :: f32(3.0)
DRONE_TURN_SPEED :: f32(1.8)
DRONE_PITCH_SPEED :: f32(1.2)
DRONE_MIN_HEIGHT :: f32(0.6)
DRONE_MAX_HEIGHT :: f32(8.0)
DRONE_MIN_PITCH :: f32(-0.75)
DRONE_MAX_PITCH :: f32(0.55)

Field_Control_Mode :: enum {
	Player,
	Drone_FPV,
}

Field_Map_Kind :: enum {
	Forest,
	Plains,
	Mountains,
	Desert,
}

Field_Scene :: struct {
	field:       map_tools.Field_Map,
	player:      states.Player,
	player_tile: map_tools.Map_Point,
	show_cover:  bool,
	debug:       bool,
	mode:        Field_Control_Mode,
	drone:       Player_Drone,
}

Player_Drone :: struct {
	active:   bool,
	position: rl.Vector3,
	yaw:      f32,
	pitch:    f32,
}

FOREST_FIELD_TILES := [?]map_tools.Map_Tile {
	.Dense_Forest,
	.Forest,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Forest,
	.Mountain,
	.Ridge,
	.Forest,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Drone_Launch,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Ridge,
	.Forest,
	.Forest,
	.Forest,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Forest,
	.Dense_Forest,
	.Forest,
	.Grass,
	.Grass,
	.Grass,
	.Enemy_Outpost,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Forest,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Dense_Forest,
	.Grass,
	.Grass,
	.Grass,
	.Forest,
	.Forest,
	.Grass,
	.Drone_Launch,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Forest,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Forest,
	.Forest,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Dense_Forest,
	.Forest,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Dense_Forest,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Forest,
	.Forest,
	.Dense_Forest,
	.Forest,
	.Ridge,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Mountain,
	.Forest,
	.Forest,
	.Forest,
	.Ridge,
	.Forest,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Forest,
	.Forest,
	.Forest,
	.Dense_Forest,
}

PLAINS_FIELD_TILES := [?]map_tools.Map_Tile {
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Drone_Launch,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Enemy_Outpost,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Drone_Launch,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Tall_Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
}

MOUNTAIN_FIELD_TILES := [?]map_tools.Map_Tile {
	.Mountain,
	.Mountain,
	.Ridge,
	.Ridge,
	.Grass,
	.Grass,
	.Ridge,
	.Mountain,
	.Mountain,
	.Mountain,
	.Ridge,
	.Ridge,
	.Mountain,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Drone_Launch,
	.Grass,
	.Grass,
	.Ridge,
	.Mountain,
	.Mountain,
	.Ridge,
	.Ridge,
	.Grass,
	.Grass,
	.Ridge,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Ridge,
	.Ridge,
	.Mountain,
	.Ridge,
	.Grass,
	.Ridge,
	.Mountain,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Enemy_Outpost,
	.Grass,
	.Ridge,
	.Mountain,
	.Grass,
	.Grass,
	.Ridge,
	.Ridge,
	.Grass,
	.Grass,
	.Mountain,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Ridge,
	.Grass,
	.Drone_Launch,
	.Grass,
	.Ridge,
	.Grass,
	.Grass,
	.Ridge,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Ridge,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Ridge,
	.Ridge,
	.Mountain,
	.Ridge,
	.Grass,
	.Grass,
	.Ridge,
	.Mountain,
	.Mountain,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Ridge,
	.Grass,
	.Grass,
	.Ridge,
	.Mountain,
	.Mountain,
	.Mountain,
	.Mountain,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Grass,
	.Ridge,
	.Mountain,
	.Mountain,
	.Ridge,
	.Mountain,
	.Mountain,
	.Mountain,
	.Ridge,
	.Grass,
	.Grass,
	.Grass,
	.Ridge,
	.Mountain,
	.Mountain,
	.Ridge,
	.Ridge,
}

DESERT_FIELD_TILES := [?]map_tools.Map_Tile {
	.Dune,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Ridge,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Drone_Launch,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Enemy_Outpost,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Drone_Launch,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Ridge,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Ridge,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Dune,
	.Sand,
	.Sand,
	.Sand,
	.Dune,
}

field_scene_init :: proc(kind: Field_Map_Kind = .Forest) -> Field_Scene {
	field := field_map_for(kind)
	return {
		field = field,
		player = states.player_init(),
		player_tile = field.player_start,
		show_cover = false,
		debug = false,
		mode = .Player,
	}
}

field_scene_with_debug_init :: proc(kind: Field_Map_Kind, debug: bool) -> Field_Scene {
	scene := field_scene_init(kind)
	scene.debug = debug
	return scene
}

field_map_for :: proc(kind: Field_Map_Kind) -> map_tools.Field_Map {
	switch kind {
	case .Forest:
		return map_tools.Field_Map {
			name = "Border Forest",
			biome = .Forest,
			width = FIELD_MAP_WIDTH,
			height = FIELD_MAP_HEIGHT,
			tile_size = FIELD_TILE_SIZE,
			tiles = FOREST_FIELD_TILES[:],
			player_start = map_tools.Map_Point{x = 5, z = 8},
		}
	case .Plains:
		return map_tools.Field_Map {
			name = "Signal Plains",
			biome = .Plains,
			width = FIELD_MAP_WIDTH,
			height = FIELD_MAP_HEIGHT,
			tile_size = FIELD_TILE_SIZE,
			tiles = PLAINS_FIELD_TILES[:],
			player_start = map_tools.Map_Point{x = 5, z = 8},
		}
	case .Mountains:
		return map_tools.Field_Map {
			name = "Ridge Pass",
			biome = .Mountains,
			width = FIELD_MAP_WIDTH,
			height = FIELD_MAP_HEIGHT,
			tile_size = FIELD_TILE_SIZE,
			tiles = MOUNTAIN_FIELD_TILES[:],
			player_start = map_tools.Map_Point{x = 5, z = 8},
		}
	case .Desert:
		return map_tools.Field_Map {
			name = "Glass Desert",
			biome = .Desert,
			width = FIELD_MAP_WIDTH,
			height = FIELD_MAP_HEIGHT,
			tile_size = FIELD_TILE_SIZE,
			tiles = DESERT_FIELD_TILES[:],
			player_start = map_tools.Map_Point{x = 5, z = 8},
		}
	}

	return map_tools.Field_Map{}
}

update_field_scene :: proc(scene: ^Field_Scene, dt: f32) -> Scene_Result {
	states.update_player_timers(&scene.player, dt)

	if rl.IsKeyPressed(.X) {
		toggle_player_drone(scene)
	}

	if scene.mode == .Player {
		update_field_player(scene)
	}

	if scene.mode == .Drone_FPV {
		update_player_drone(scene, dt)
	}

	return .Running
}

update_field_player :: proc(scene: ^Field_Scene) {
	if rl.IsKeyDown(.LEFT_CONTROL) || rl.IsKeyDown(.RIGHT_CONTROL) {
		states.start_player_crouch(&scene.player)
	} else {
		states.stop_player_crouch(&scene.player)
	}

	if rl.IsKeyPressed(.SPACE) {
		states.start_player_jump(&scene.player)
	}
	if rl.IsKeyPressed(.Q) {
		states.deploy_player_shield_cover(&scene.player)
	}
	if rl.IsKeyPressed(.ONE) {
		states.cycle_player_weapon(&scene.player, .Sidearm)
	}
	if rl.IsKeyPressed(.TWO) {
		states.cycle_player_weapon(&scene.player, .Rifle)
	}
	if rl.IsKeyPressed(.THREE) {
		states.cycle_player_weapon(&scene.player, .Launcher)
	}
	if rl.IsKeyPressed(.F) {
		states.shoot_player_weapon(&scene.player)
	}
	if rl.IsKeyPressed(.C) {
		scene.show_cover = !scene.show_cover
	}

	running := rl.IsKeyDown(.LEFT_SHIFT) || rl.IsKeyDown(.RIGHT_SHIFT)
	step_count := running ? 2 : 1
	moved := false

	if rl.IsKeyPressed(.W) || rl.IsKeyPressed(.UP) {
		moved = try_move_field_player_steps(scene, 0, -1, step_count) || moved
	}
	if rl.IsKeyPressed(.S) || rl.IsKeyPressed(.DOWN) {
		moved = try_move_field_player_steps(scene, 0, 1, step_count) || moved
	}
	if rl.IsKeyPressed(.A) || rl.IsKeyPressed(.LEFT) {
		moved = try_move_field_player_steps(scene, 1, 0, step_count) || moved
	}
	if rl.IsKeyPressed(.D) || rl.IsKeyPressed(.RIGHT) {
		moved = try_move_field_player_steps(scene, -1, 0, step_count) || moved
	}

	states.set_player_move_animation(&scene.player, moved, running && moved)
}

toggle_player_drone :: proc(scene: ^Field_Scene) {
	if scene.mode == .Drone_FPV {
		scene.mode = .Player
		states.set_player_move_animation(&scene.player, false, false)
		return
	}

	if !scene.drone.active {
		player_position := map_tools.tile_world_position(
			&scene.field,
			scene.player_tile.x,
			scene.player_tile.z,
		)
		scene.drone = Player_Drone {
			active   = true,
			position = rl.Vector3 {
				player_position.x,
				DRONE_LAUNCH_HEIGHT,
				player_position.z - scene.field.tile_size * 0.45,
			},
			yaw      = -math.PI / 2,
			pitch    = -0.18,
		}
	}

	scene.mode = .Drone_FPV
	scene.player.animation = .Using_Drone
}

update_player_drone :: proc(scene: ^Field_Scene, dt: f32) {
	if rl.IsKeyDown(.LEFT) {
		scene.drone.yaw -= DRONE_TURN_SPEED * dt
	}
	if rl.IsKeyDown(.RIGHT) {
		scene.drone.yaw += DRONE_TURN_SPEED * dt
	}
	if rl.IsKeyDown(.UP) {
		scene.drone.pitch += DRONE_PITCH_SPEED * dt
	}
	if rl.IsKeyDown(.DOWN) {
		scene.drone.pitch -= DRONE_PITCH_SPEED * dt
	}

	scene.drone.pitch = clamp_f32(scene.drone.pitch, DRONE_MIN_PITCH, DRONE_MAX_PITCH)
	forward := drone_forward(scene.drone)
	right := rl.Vector3{forward.z, 0, -forward.x}
	movement := rl.Vector3{}

	if rl.IsKeyDown(.W) {
		movement = add_vector3(movement, rl.Vector3{forward.x, 0, forward.z})
	}
	if rl.IsKeyDown(.S) {
		movement = add_vector3(movement, rl.Vector3{-forward.x, 0, -forward.z})
	}
	if rl.IsKeyDown(.D) {
		movement = add_vector3(movement, right)
	}
	if rl.IsKeyDown(.A) {
		movement = add_vector3(movement, rl.Vector3{-right.x, 0, -right.z})
	}
	if rl.IsKeyDown(.SPACE) {
		movement.y += 1
	}
	if rl.IsKeyDown(.LEFT_SHIFT) {
		movement.y -= 1
	}

	if movement.x != 0 || movement.y != 0 || movement.z != 0 {
		movement = normalize_vector3(movement)
		velocity := rl.Vector3 {
			movement.x * DRONE_MOVE_SPEED,
			movement.y * DRONE_VERTICAL_SPEED,
			movement.z * DRONE_MOVE_SPEED,
		}
		scene.drone.position = add_vector3(
			scene.drone.position,
			rl.Vector3{velocity.x * dt, velocity.y * dt, velocity.z * dt},
		)
	}

	clamp_drone_to_field(scene)
}

try_move_field_player :: proc(scene: ^Field_Scene, dx, dz: int) {
	if !states.player_can_move(&scene.player) {
		return
	}

	next := map_tools.Map_Point {
		x = scene.player_tile.x + dx,
		z = scene.player_tile.z + dz,
	}
	tile := map_tools.map_tile_at(&scene.field, next.x, next.z)

	if tile == .Empty || map_tools.tile_blocks_walking(tile) {
		return
	}

	scene.player_tile = next
}

try_move_field_player_steps :: proc(scene: ^Field_Scene, dx, dz, steps: int) -> bool {
	moved := false
	for step := 0; step < steps; step += 1 {
		before := scene.player_tile
		try_move_field_player(scene, dx, dz)
		if scene.player_tile.x == before.x && scene.player_tile.z == before.z {
			return moved
		}
		moved = true
	}

	return moved
}

draw_field_scene :: proc(scene: ^Field_Scene) {
	player_position := map_tools.tile_world_position(
		&scene.field,
		scene.player_tile.x,
		scene.player_tile.z,
	)
	camera := field_scene_camera(scene)
	hovered := map_tools.hovered_tile_from_cursor(&scene.field, camera)

	rl.ClearBackground(map_tools.NIGHT_SKY)
	rl.BeginMode3D(camera)
	map_tools.draw_field_map(
		&scene.field,
		player_position,
		map_tools.Field_Draw_Options{show_grid = true, show_cover = scene.show_cover},
	)
	draw_player_agent(scene, player_position)
	if scene.drone.active && scene.mode == .Player {
		draw_player_drone(scene)
	}
	if scene.debug {
		map_tools.draw_hovered_tile_marker(&scene.field, hovered)
	}
	rl.EndMode3D()

	rl.DrawText(scene.field.name, 32, 28, 28, rl.RAYWHITE)
	if scene.mode == .Drone_FPV {
		rl.DrawText(
			"DRONE FPV  WASD: fly   Arrows: look   Space/Shift: altitude   X: return",
			32,
			64,
			20,
			rl.YELLOW,
		)
		draw_drone_fpv_overlay()
	} else {
		rl.DrawText(
			"WASD/Arrows: move   Shift: run   Ctrl: crouch   Space: jump   Q: shield   F: shoot   1/2/3: weapon   X: drone",
			32,
			64,
			20,
			rl.LIGHTGRAY,
		)
	}
	draw_player_status_hud(&scene.player)
	if scene.debug {
		map_tools.draw_hovered_tile_panel(hovered)
		rl.DrawText("Debug: cursor tile inspector enabled", 32, 92, 18, rl.YELLOW)
	}
}

draw_player_agent :: proc(scene: ^Field_Scene, position: rl.Vector3) {
	draw_position := position
	height := scene.field.tile_size * 0.46
	if scene.player.posture == .Crouching {
		height *= 0.62
	}
	if scene.player.posture == .Airborne {
		draw_position.y += scene.field.tile_size * 0.42
	}

	body_size := rl.Vector3{scene.field.tile_size * 0.22, height, scene.field.tile_size * 0.22}
	body_position := rl.Vector3{draw_position.x, draw_position.y + height * 0.5, draw_position.z}
	rl.DrawCubeV(body_position, body_size, states.player_draw_color(&scene.player))
	rl.DrawCubeWiresV(body_position, body_size, rl.RAYWHITE)

	if scene.player.shield_deployed {
		draw_player_shield_cover(scene, position)
	}
	if scene.player.animation == .Shooting {
		draw_player_weapon_flash(scene, position)
	}
}

draw_player_shield_cover :: proc(scene: ^Field_Scene, position: rl.Vector3) {
	shield_size := rl.Vector3 {
		scene.field.tile_size * 0.65,
		scene.field.tile_size * 0.72,
		scene.field.tile_size * 0.08,
	}
	shield_position := rl.Vector3 {
		position.x,
		shield_size.y * 0.5,
		position.z - scene.field.tile_size * 0.42,
	}
	rl.DrawCubeV(shield_position, shield_size, rl.ColorAlpha(rl.BLUE, 0.55))
	rl.DrawCubeWiresV(shield_position, shield_size, rl.SKYBLUE)
}

draw_player_weapon_flash :: proc(scene: ^Field_Scene, position: rl.Vector3) {
	flash_size := rl.Vector3 {
		scene.field.tile_size * 0.16,
		scene.field.tile_size * 0.16,
		scene.field.tile_size * 0.42,
	}
	flash_position := rl.Vector3 {
		position.x,
		scene.field.tile_size * 0.42,
		position.z - scene.field.tile_size * 0.36,
	}
	rl.DrawCubeV(flash_position, flash_size, rl.ORANGE)
}

draw_player_status_hud :: proc(player: ^states.Player) {
	weapon := player.inventory.weapons[player.inventory.current_weapon]
	rl.DrawText(
		states.player_animation_name(player.animation),
		32,
		rl.GetScreenHeight() - 112,
		18,
		rl.LIGHTGRAY,
	)
	rl.DrawText(
		states.player_weapon_name(player.inventory.current_weapon),
		32,
		rl.GetScreenHeight() - 88,
		18,
		rl.RAYWHITE,
	)
	rl.DrawText("HP", 32, rl.GetScreenHeight() - 58, 18, rl.RAYWHITE)
	rl.DrawRectangle(72, rl.GetScreenHeight() - 58, player.health * 2, 18, rl.GREEN)
	rl.DrawRectangleLines(
		72,
		rl.GetScreenHeight() - 58,
		states.PLAYER_MAX_HEALTH * 2,
		18,
		rl.RAYWHITE,
	)
	if weapon.ammo <= 0 {
		rl.DrawText("AMMO EMPTY", 32, rl.GetScreenHeight() - 34, 18, rl.RED)
	} else {
		rl.DrawText("Ammo OK", 32, rl.GetScreenHeight() - 34, 18, rl.LIGHTGRAY)
	}
}

field_scene_camera :: proc(scene: ^Field_Scene) -> rl.Camera3D {
	if scene.mode == .Drone_FPV && scene.drone.active {
		return drone_fpv_camera(scene.drone)
	}

	return map_tools.field_camera(&scene.field)
}

drone_fpv_camera :: proc(drone: Player_Drone) -> rl.Camera3D {
	forward := drone_forward(drone)
	return rl.Camera3D {
		position = drone.position,
		target = add_vector3(drone.position, forward),
		up = rl.Vector3{0, 1, 0},
		fovy = 68,
		projection = .PERSPECTIVE,
	}
}

drone_forward :: proc(drone: Player_Drone) -> rl.Vector3 {
	flat := math.cos(drone.pitch)
	return rl.Vector3 {
		math.cos(drone.yaw) * flat,
		math.sin(drone.pitch),
		math.sin(drone.yaw) * flat,
	}
}

draw_player_drone :: proc(scene: ^Field_Scene) {
	drones.draw_quadcopter(
		scene.drone.position,
		rl.Vector3 {
			scene.field.tile_size * 0.42,
			scene.field.tile_size * 0.22,
			scene.field.tile_size * 0.42,
		},
		rl.SKYBLUE,
	)
}

draw_drone_fpv_overlay :: proc() {
	center_x := rl.GetScreenWidth() / 2
	center_y := rl.GetScreenHeight() / 2
	rl.DrawLine(center_x - 18, center_y, center_x - 6, center_y, rl.GREEN)
	rl.DrawLine(center_x + 6, center_y, center_x + 18, center_y, rl.GREEN)
	rl.DrawLine(center_x, center_y - 18, center_x, center_y - 6, rl.GREEN)
	rl.DrawLine(center_x, center_y + 6, center_x, center_y + 18, rl.GREEN)
	rl.DrawRectangleLines(
		24,
		24,
		rl.GetScreenWidth() - 48,
		rl.GetScreenHeight() - 48,
		rl.ColorAlpha(rl.GREEN, 0.45),
	)
}

clamp_drone_to_field :: proc(scene: ^Field_Scene) {
	bounds := map_tools.map_world_bounds(&scene.field)
	half_x := bounds.x * 0.5 - scene.field.tile_size * 0.25
	half_z := bounds.z * 0.5 - scene.field.tile_size * 0.25
	scene.drone.position.x = clamp_f32(scene.drone.position.x, -half_x, half_x)
	scene.drone.position.y = clamp_f32(scene.drone.position.y, DRONE_MIN_HEIGHT, DRONE_MAX_HEIGHT)
	scene.drone.position.z = clamp_f32(scene.drone.position.z, -half_z, half_z)
}

normalize_vector3 :: proc(v: rl.Vector3) -> rl.Vector3 {
	length := math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
	if length <= 0 {
		return rl.Vector3{}
	}

	return rl.Vector3{v.x / length, v.y / length, v.z / length}
}

clamp_f32 :: proc(value, min, max: f32) -> f32 {
	if value < min {
		return min
	}
	if value > max {
		return max
	}

	return value
}
