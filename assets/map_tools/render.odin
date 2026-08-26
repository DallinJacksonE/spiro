package map_tools

import drones "../drones"
import mountains "../mountains"
import rl "vendor:raylib"
import trees "../trees"

GROUND_THICKNESS :: f32(0.08)

NIGHT_SKY :: rl.Color{4, 6, 18, 255}
FOREST_GROUND :: rl.Color{18, 56, 28, 255}
PLAINS_GROUND :: rl.Color{62, 120, 45, 255}
MOUNTAIN_GROUND :: rl.Color{68, 66, 58, 255}
DESERT_GROUND :: rl.Color{182, 150, 88, 255}
TALL_GRASS :: rl.Color{76, 150, 54, 255}
DUNE_COLOR :: rl.Color{210, 178, 104, 255}
OUTPOST_COLOR :: rl.Color{96, 78, 70, 255}
LAUNCH_PAD_COLOR :: rl.Color{82, 92, 102, 255}
PLAYER_COLOR :: rl.Color{230, 232, 224, 255}

Field_Draw_Options :: struct {
	show_grid:  bool,
	show_cover: bool,
}

field_camera :: proc(field: ^Field_Map) -> rl.Camera3D {
	bounds := map_world_bounds(field)
	return rl.Camera3D {
		position   = rl.Vector3{0, 14, bounds.z * 0.72},
		target     = rl.Vector3{0, 0, 0},
		up         = rl.Vector3{0, 1, 0},
		fovy       = 45,
		projection = .PERSPECTIVE,
	}
}

draw_field_map :: proc(field: ^Field_Map, player_position: rl.Vector3, options: Field_Draw_Options) {
	for z := 0; z < field.height; z += 1 {
		for x := 0; x < field.width; x += 1 {
			tile := map_tile_at(field, x, z)
			position := tile_world_position(field, x, z)
			draw_map_tile(field.biome, tile, position, field.tile_size, options)
		}
	}
}

draw_map_tile :: proc(biome: Map_Biome, tile: Map_Tile, position: rl.Vector3, tile_size: f32, options: Field_Draw_Options) {
	if tile == .Empty {
		return
	}

	ground_color := tile_ground_color(biome, tile)
	ground_size := rl.Vector3{tile_size, GROUND_THICKNESS, tile_size}
	ground_position := rl.Vector3{position.x, -GROUND_THICKNESS * 0.5, position.z}
	rl.DrawCubeV(ground_position, ground_size, ground_color)

	if options.show_grid {
		rl.DrawCubeWiresV(ground_position, ground_size, rl.DARKGRAY)
	}

	switch tile {
	case .Empty:
	case .Tall_Grass:
		draw_grass_cover(position, tile_size)
	case .Forest:
		trees.draw_pine(position, rl.Vector3{tile_size * 0.62, tile_size * 1.4, tile_size * 0.62}, rl.BROWN, rl.DARKGREEN)
	case .Dense_Forest:
		trees.draw_pine(rl.Vector3{position.x - tile_size * 0.16, position.y, position.z + tile_size * 0.10}, rl.Vector3{tile_size * 0.58, tile_size * 1.55, tile_size * 0.58}, rl.BROWN, rl.DARKGREEN)
		trees.draw_oak(rl.Vector3{position.x + tile_size * 0.18, position.y, position.z - tile_size * 0.16}, rl.Vector3{tile_size * 0.54, tile_size * 1.25, tile_size * 0.54}, rl.BROWN, rl.GREEN)
	case .Mountain:
		mountains.draw_mountain(position, rl.Vector3{tile_size * 1.1, tile_size * 1.6, tile_size * 1.1}, rl.DARKGRAY)
	case .Ridge:
		mountains.draw_mountain(position, rl.Vector3{tile_size * 1.0, tile_size * 0.8, tile_size * 0.8}, rl.GRAY)
	case .Dune:
		draw_dune(position, tile_size)
	case .Enemy_Outpost:
		draw_enemy_outpost(position, tile_size)
	case .Drone_Launch:
		draw_drone_launch(position, tile_size)
	case .Grass, .Sand:
	}

	if options.show_cover && tile_has_cover(tile) {
		draw_cover_ring(position, tile_size)
	}
}

tile_ground_color :: proc(biome: Map_Biome, tile: Map_Tile) -> rl.Color {
	switch tile {
	case .Grass, .Tall_Grass, .Forest, .Dense_Forest:
		return biome == .Desert ? DESERT_GROUND : biome_base_color(biome)
	case .Mountain, .Ridge:
		return MOUNTAIN_GROUND
	case .Sand, .Dune:
		return DESERT_GROUND
	case .Enemy_Outpost:
		return OUTPOST_COLOR
	case .Drone_Launch:
		return LAUNCH_PAD_COLOR
	case .Empty:
		return rl.BLACK
	}

	return biome_base_color(biome)
}

biome_base_color :: proc(biome: Map_Biome) -> rl.Color {
	switch biome {
	case .Forest:
		return FOREST_GROUND
	case .Plains:
		return PLAINS_GROUND
	case .Mountains:
		return MOUNTAIN_GROUND
	case .Desert:
		return DESERT_GROUND
	}

	return PLAINS_GROUND
}

draw_grass_cover :: proc(position: rl.Vector3, tile_size: f32) {
	blade_size := rl.Vector3{tile_size * 0.12, tile_size * 0.28, tile_size * 0.12}
	rl.DrawCubeV(rl.Vector3{position.x - tile_size * 0.22, tile_size * 0.14, position.z}, blade_size, TALL_GRASS)
	rl.DrawCubeV(rl.Vector3{position.x, tile_size * 0.16, position.z - tile_size * 0.20}, blade_size, TALL_GRASS)
	rl.DrawCubeV(rl.Vector3{position.x + tile_size * 0.24, tile_size * 0.13, position.z + tile_size * 0.18}, blade_size, TALL_GRASS)
}

draw_dune :: proc(position: rl.Vector3, tile_size: f32) {
	dune_size := rl.Vector3{tile_size * 0.82, tile_size * 0.24, tile_size * 0.50}
	rl.DrawCubeV(rl.Vector3{position.x, tile_size * 0.12, position.z}, dune_size, DUNE_COLOR)
	rl.DrawCubeWiresV(rl.Vector3{position.x, tile_size * 0.12, position.z}, dune_size, rl.BROWN)
}

draw_enemy_outpost :: proc(position: rl.Vector3, tile_size: f32) {
	base_size := rl.Vector3{tile_size * 0.72, tile_size * 0.32, tile_size * 0.72}
	tower_size := rl.Vector3{tile_size * 0.25, tile_size * 0.92, tile_size * 0.25}
	rl.DrawCubeV(rl.Vector3{position.x, tile_size * 0.16, position.z}, base_size, OUTPOST_COLOR)
	rl.DrawCubeWiresV(rl.Vector3{position.x, tile_size * 0.16, position.z}, base_size, rl.RAYWHITE)
	rl.DrawCubeV(rl.Vector3{position.x, tile_size * 0.54, position.z}, tower_size, rl.DARKGRAY)
	rl.DrawCubeWiresV(rl.Vector3{position.x, tile_size * 0.54, position.z}, tower_size, rl.RED)
}

draw_drone_launch :: proc(position: rl.Vector3, tile_size: f32) {
	pad_size := rl.Vector3{tile_size * 0.78, tile_size * 0.08, tile_size * 0.78}
	rl.DrawCubeV(rl.Vector3{position.x, tile_size * 0.04, position.z}, pad_size, LAUNCH_PAD_COLOR)
	rl.DrawCubeWiresV(rl.Vector3{position.x, tile_size * 0.04, position.z}, pad_size, rl.RAYWHITE)
	drones.draw_quadcopter(rl.Vector3{position.x, tile_size * 0.62, position.z}, rl.Vector3{tile_size * 0.72, tile_size * 0.38, tile_size * 0.72}, rl.LIGHTGRAY)
}

draw_cover_ring :: proc(position: rl.Vector3, tile_size: f32) {
	rl.DrawCubeWiresV(rl.Vector3{position.x, tile_size * 0.03, position.z}, rl.Vector3{tile_size * 0.92, tile_size * 0.06, tile_size * 0.92}, rl.DARKGREEN)
}

draw_player_marker :: proc(position: rl.Vector3, tile_size: f32) {
	body_size := rl.Vector3{tile_size * 0.22, tile_size * 0.46, tile_size * 0.22}
	body_position := rl.Vector3{position.x, tile_size * 0.23, position.z}
	rl.DrawCubeV(body_position, body_size, PLAYER_COLOR)
	rl.DrawCubeWiresV(body_position, body_size, rl.RAYWHITE)
}
