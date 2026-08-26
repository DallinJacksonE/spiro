package scenes

import drones "../assets/drones"
import map_tools "../assets/map_tools"
import states "../states"
import "core:math"
import rl "vendor:raylib"

FIELD_TILE_SIZE :: f32(3.0)
FIELD_MAP_WIDTH :: 12
FIELD_MAP_HEIGHT :: 10
FIELD_REMOVED_BLOCK_COUNT :: FIELD_MAP_WIDTH * FIELD_MAP_HEIGHT * map_tools.TILE_BLOCK_COUNT
PLAYER_HEAD_HEIGHT :: f32(1.65)
PLAYER_WALK_SPEED :: f32(2.4)
PLAYER_RUN_SPEED :: f32(5.1)
PLAYER_RADIUS :: f32(0.28)
PLAYER_MOUSE_SENSITIVITY :: f32(0.003)
PLAYER_MIN_PITCH :: f32(-1.25)
PLAYER_MAX_PITCH :: f32(1.05)
SHOVEL_REACH :: f32(2.2)
SHOVEL_RADIUS :: f32(2.0)
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
	field:          map_tools.Field_Map,
	player:         states.Player,
	player_tile:    map_tools.Map_Point,
	player_position: rl.Vector3,
	player_yaw:     f32,
	player_pitch:   f32,
	show_cover:     bool,
	debug:          bool,
	mode:           Field_Control_Mode,
	drone:          Player_Drone,
	removed_blocks: [FIELD_REMOVED_BLOCK_COUNT]bool,
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
	.Shore,
	.Shallow_Water,
	.Deep_Water,
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
	player_position := map_tools.tile_world_position(&field, field.player_start.x, field.player_start.z)
	rl.DisableCursor()
	return {
		field = field,
		player = states.player_init(),
		player_tile = field.player_start,
		player_position = player_position,
		player_yaw = -math.PI / 2,
		player_pitch = 0,
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
		update_field_player(scene, dt)
	}

	if scene.mode == .Drone_FPV {
		update_player_drone(scene, dt)
	}

	return .Running
}

update_field_player :: proc(scene: ^Field_Scene, dt: f32) {
	update_player_mouse_look(scene)

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
		states.cycle_player_weapon(&scene.player, .Shovel)
	}
	if rl.IsKeyPressed(.TWO) {
		states.cycle_player_weapon(&scene.player, .Sidearm)
	}
	if rl.IsKeyPressed(.THREE) {
		states.cycle_player_weapon(&scene.player, .Rifle)
	}
	if rl.IsKeyPressed(.FOUR) {
		states.cycle_player_weapon(&scene.player, .Launcher)
	}
	if rl.IsMouseButtonPressed(.LEFT) || rl.IsKeyPressed(.F) {
		use_player_weapon(scene)
	}
	if rl.IsKeyPressed(.C) {
		scene.show_cover = !scene.show_cover
	}

	running := rl.IsKeyDown(.LEFT_SHIFT) || rl.IsKeyDown(.RIGHT_SHIFT)
	moved := move_field_player_continuous(scene, dt, running)
	if moved && scene.player.shield_deployed {
		states.deactivate_player_shield_cover(&scene.player)
	}

	point, inside := map_tools.world_to_tile(&scene.field, scene.player_position)
	if inside {
		scene.player_tile = point
	}
	states.set_player_move_animation(&scene.player, moved, running && moved)
}

update_player_mouse_look :: proc(scene: ^Field_Scene) {
	mouse_delta := rl.GetMouseDelta()
	scene.player_yaw += mouse_delta.x * PLAYER_MOUSE_SENSITIVITY
	scene.player_pitch -= mouse_delta.y * PLAYER_MOUSE_SENSITIVITY
	scene.player_pitch = clamp_f32(scene.player_pitch, PLAYER_MIN_PITCH, PLAYER_MAX_PITCH)
}

move_field_player_continuous :: proc(scene: ^Field_Scene, dt: f32, running: bool) -> bool {
	if !states.player_can_move(&scene.player) {
		return false
	}

	forward := player_forward(scene)
	flat_forward := normalize_vector3(rl.Vector3{forward.x, 0, forward.z})
	right := rl.Vector3{-flat_forward.z, 0, flat_forward.x}
	movement := rl.Vector3{}

	if rl.IsKeyDown(.W) || rl.IsKeyDown(.UP) {
		movement = add_vector3(movement, flat_forward)
	}
	if rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN) {
		movement = add_vector3(movement, rl.Vector3{-flat_forward.x, 0, -flat_forward.z})
	}
	if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) {
		movement = add_vector3(movement, right)
	}
	if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT) {
		movement = add_vector3(movement, rl.Vector3{-right.x, 0, -right.z})
	}

	if movement.x == 0 && movement.z == 0 {
		return false
	}

	movement = normalize_vector3(movement)
	speed := running ? PLAYER_RUN_SPEED : PLAYER_WALK_SPEED
	next := add_vector3(scene.player_position, rl.Vector3{movement.x * speed * dt, 0, movement.z * speed * dt})
	next = clamp_player_position_to_field(scene, next)
	if !field_position_walkable(scene, next) {
		return false
	}

	scene.player_position = next
	return true
}

clamp_player_position_to_field :: proc(scene: ^Field_Scene, position: rl.Vector3) -> rl.Vector3 {
	bounds := map_tools.map_world_bounds(&scene.field)
	half_x := bounds.x * 0.5 - PLAYER_RADIUS
	half_z := bounds.z * 0.5 - PLAYER_RADIUS
	clamped := position
	clamped.x = clamp_f32(clamped.x, -half_x, half_x)
	clamped.z = clamp_f32(clamped.z, -half_z, half_z)
	return clamped
}

field_position_walkable :: proc(scene: ^Field_Scene, position: rl.Vector3) -> bool {
	point, inside := map_tools.world_to_tile(&scene.field, position)
	if !inside {
		return false
	}

	tile := map_tools.map_tile_at(&scene.field, point.x, point.z)
	return tile != .Empty && !map_tools.tile_blocks_walking(tile)
}

use_player_weapon :: proc(scene: ^Field_Scene) {
	if scene.player.inventory.current_weapon == .Shovel {
		if states.shoot_player_weapon(&scene.player) {
			dig_player_shovel_sphere(scene)
		}
		return
	}

	states.shoot_player_weapon(&scene.player)
}

dig_player_shovel_sphere :: proc(scene: ^Field_Scene) {
	center := add_vector3(player_head_position(scene), scale_vector3(player_forward(scene), SHOVEL_REACH))
	radius_squared := SHOVEL_RADIUS * SHOVEL_RADIUS

	for tile_z := 0; tile_z < scene.field.height; tile_z += 1 {
		for tile_x := 0; tile_x < scene.field.width; tile_x += 1 {
			tile := map_tools.map_tile_at(&scene.field, tile_x, tile_z)
			for level := 0; level < map_tools.TILE_BLOCKS_PER_AXIS; level += 1 {
				block_level := map_tools.tile_block_level(tile, level)
				if !block_level.attributes.tunnelable {
					continue
				}

				for block_z := 0; block_z < map_tools.TILE_BLOCKS_PER_AXIS; block_z += 1 {
					for block_x := 0; block_x < map_tools.TILE_BLOCKS_PER_AXIS; block_x += 1 {
						point := map_tools.Map_Block_Point {
							tile_x = tile_x,
							tile_z = tile_z,
							block_x = block_x,
							level = level,
							block_z = block_z,
						}
						block_position := map_tools.map_tile_block_world_position(&scene.field, point)
						if distance_squared(block_position, center) <= radius_squared {
							remove_map_block(scene, point)
						}
					}
				}
			}
		}
	}

	collapse_unsupported_blocks(scene)
}

remove_map_block :: proc(scene: ^Field_Scene, point: map_tools.Map_Block_Point) {
	index, inside := map_tools.map_tile_block_index(&scene.field, point)
	if inside && index < len(scene.removed_blocks) {
		scene.removed_blocks[index] = true
	}
}

collapse_unsupported_blocks :: proc(scene: ^Field_Scene) {
	changed := true
	for changed {
		changed = false
		for tile_z := 0; tile_z < scene.field.height; tile_z += 1 {
			for tile_x := 0; tile_x < scene.field.width; tile_x += 1 {
				tile := map_tools.map_tile_at(&scene.field, tile_x, tile_z)
				for level := map_tools.TILE_BLOCKS_PER_AXIS - 2; level >= 0; level -= 1 {
					block_level := map_tools.tile_block_level(tile, level)
					if !block_level.attributes.falls_without_support {
						continue
					}
					for block_z := 0; block_z < map_tools.TILE_BLOCKS_PER_AXIS; block_z += 1 {
						for block_x := 0; block_x < map_tools.TILE_BLOCKS_PER_AXIS; block_x += 1 {
							point := map_tools.Map_Block_Point{tile_x = tile_x, tile_z = tile_z, block_x = block_x, level = level, block_z = block_z}
							support := point
							support.level = level + 1
							if !map_block_removed(scene, point) && map_block_removed(scene, support) {
								remove_map_block(scene, point)
								changed = true
							}
						}
					}
				}
			}
		}
	}
}

map_block_removed :: proc(scene: ^Field_Scene, point: map_tools.Map_Block_Point) -> bool {
	index, inside := map_tools.map_tile_block_index(&scene.field, point)
	return inside && index < len(scene.removed_blocks) && scene.removed_blocks[index]
}

toggle_player_drone :: proc(scene: ^Field_Scene) {
	if scene.mode == .Drone_FPV {
		scene.mode = .Player
		rl.DisableCursor()
		states.set_player_move_animation(&scene.player, false, false)
		return
	}

	if !scene.drone.active {
		player_position := scene.player_position
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
	rl.EnableCursor()
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
	right := rl.Vector3{-forward.z, 0, forward.x}
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
	player_position := scene.player_position
	camera := field_scene_camera(scene)
	hovered := map_tools.hovered_tile_from_cursor(&scene.field, camera)

	rl.ClearBackground(map_tools.NIGHT_SKY)
	rl.BeginMode3D(camera)
	map_tools.draw_field_map(
		&scene.field,
		player_position,
		map_tools.Field_Draw_Options {
			show_grid = true,
			show_cover = scene.show_cover,
			removed_blocks = scene.removed_blocks[:],
		},
	)
	if scene.mode == .Drone_FPV {
		draw_player_agent(scene, player_position)
	}
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
			"Mouse: look/shoot   WASD: move   Shift: run   Ctrl: crouch   Q: shield   1: shovel 2/3/4: weapons   X: drone",
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
	forward := normalize_vector3(rl.Vector3{player_forward(scene).x, 0, player_forward(scene).z})
	shield_size := rl.Vector3 {
		scene.field.tile_size * 0.65,
		scene.field.tile_size * 0.72,
		scene.field.tile_size * 0.08,
	}
	shield_position := rl.Vector3 {
		position.x + forward.x * scene.field.tile_size * 0.42,
		shield_size.y * 0.5,
		position.z + forward.z * scene.field.tile_size * 0.42,
	}
	rl.DrawCubeV(shield_position, shield_size, rl.ColorAlpha(rl.BLUE, 0.55))
	rl.DrawCubeWiresV(shield_position, shield_size, rl.SKYBLUE)
}

draw_player_weapon_flash :: proc(scene: ^Field_Scene, position: rl.Vector3) {
	forward := player_forward(scene)
	flash_size := rl.Vector3 {
		scene.field.tile_size * 0.16,
		scene.field.tile_size * 0.16,
		scene.field.tile_size * 0.42,
	}
	flash_position := add_vector3(player_head_position(scene), scale_vector3(forward, scene.field.tile_size * 0.42))
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
	if weapon.kind == .Shovel {
		rl.DrawText("Shovel ready", 32, rl.GetScreenHeight() - 34, 18, rl.LIGHTGRAY)
	} else if weapon.ammo <= 0 {
		rl.DrawText("AMMO EMPTY", 32, rl.GetScreenHeight() - 34, 18, rl.RED)
	} else {
		rl.DrawText("Ammo OK", 32, rl.GetScreenHeight() - 34, 18, rl.LIGHTGRAY)
	}
}

field_scene_camera :: proc(scene: ^Field_Scene) -> rl.Camera3D {
	if scene.mode == .Drone_FPV && scene.drone.active {
		return drone_fpv_camera(scene.drone)
	}

	return player_fpv_camera(scene)
}

player_fpv_camera :: proc(scene: ^Field_Scene) -> rl.Camera3D {
	head := player_head_position(scene)
	return rl.Camera3D {
		position = head,
		target = add_vector3(head, player_forward(scene)),
		up = rl.Vector3{0, 1, 0},
		fovy = 72,
		projection = .PERSPECTIVE,
	}
}

player_head_position :: proc(scene: ^Field_Scene) -> rl.Vector3 {
	head_height := PLAYER_HEAD_HEIGHT
	if scene.player.posture == .Crouching {
		head_height *= 0.62
	}
	if scene.player.posture == .Airborne {
		head_height += scene.field.tile_size * 0.42
	}

	return rl.Vector3{scene.player_position.x, scene.player_position.y + head_height, scene.player_position.z}
}

player_forward :: proc(scene: ^Field_Scene) -> rl.Vector3 {
	flat := math.cos(scene.player_pitch)
	return normalize_vector3(rl.Vector3 {
		math.cos(scene.player_yaw) * flat,
		math.sin(scene.player_pitch),
		math.sin(scene.player_yaw) * flat,
	})
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

scale_vector3 :: proc(v: rl.Vector3, scale: f32) -> rl.Vector3 {
	return rl.Vector3{v.x * scale, v.y * scale, v.z * scale}
}

distance_squared :: proc(a, b: rl.Vector3) -> f32 {
	dx := a.x - b.x
	dy := a.y - b.y
	dz := a.z - b.z
	return dx * dx + dy * dy + dz * dz
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
