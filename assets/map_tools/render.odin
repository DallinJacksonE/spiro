package map_tools

import drones "../drones"
import mountains "../mountains"
import trees "../trees"
import rl "vendor:raylib"

GROUND_THICKNESS :: f32(0.08)

NIGHT_SKY :: rl.Color{4, 6, 18, 255}
FOREST_GROUND :: rl.Color{18, 56, 28, 255}
PLAINS_GROUND :: rl.Color{62, 120, 45, 255}
MOUNTAIN_GROUND :: rl.Color{68, 66, 58, 255}
DESERT_GROUND :: rl.Color{182, 150, 88, 255}
SANDY_DIRT :: rl.Color{150, 116, 70, 255}
DARK_CLAY :: rl.Color{80, 56, 42, 255}
SHORE :: rl.Color{182, 150, 88, 255}
SHALLOW_WATER :: rl.Color{170, 196, 245, 255}
DEEP_WATER :: rl.Color{140, 169, 255, 255}
TALL_GRASS :: rl.Color{76, 150, 54, 255}
DUNE_COLOR :: rl.Color{210, 178, 104, 255}
OUTPOST_COLOR :: rl.Color{96, 78, 70, 255}
LAUNCH_PAD_COLOR :: rl.Color{82, 92, 102, 255}
PLAYER_COLOR :: rl.Color{230, 232, 224, 255}

Field_Draw_Options :: struct {
	show_grid:      bool,
	show_cover:     bool,
	removed_blocks: []bool,
}

field_camera :: proc(field: ^Field_Map) -> rl.Camera3D {
	bounds := map_world_bounds(field)
	return rl.Camera3D {
		position = rl.Vector3{0, 14, bounds.z * 0.72},
		target = rl.Vector3{0, 0, 0},
		up = rl.Vector3{0, 1, 0},
		fovy = 45,
		projection = .PERSPECTIVE,
	}
}

draw_field_map :: proc(
	field: ^Field_Map,
	player_position: rl.Vector3,
	options: Field_Draw_Options,
) {
	for z := 0; z < field.height; z += 1 {
		for x := 0; x < field.width; x += 1 {
			tile := map_tile_at(field, x, z)
			position := tile_world_position(field, x, z)
			draw_map_tile(field, x, z, tile, position, options)
		}
	}
}

draw_map_tile :: proc(
	field: ^Field_Map,
	tile_x: int,
	tile_z: int,
	tile: Map_Tile,
	position: rl.Vector3,
	options: Field_Draw_Options,
) {
	if tile == .Empty {
		return
	}

	tile_size := field.tile_size
	draw_tile_blocks(field, tile_x, tile_z, tile, position, options)

	switch tile {
	case .Empty:
	case .Tall_Grass:
		draw_grass_cover(position, tile_size)
	case .Forest:
		trees.draw_pine(
			position,
			rl.Vector3{tile_size * 0.62, tile_size * 1.4, tile_size * 0.62},
			rl.BROWN,
			rl.DARKGREEN,
		)
	case .Dense_Forest:
		trees.draw_pine(
			rl.Vector3{position.x - tile_size * 0.16, position.y, position.z + tile_size * 0.10},
			rl.Vector3{tile_size * 0.58, tile_size * 1.55, tile_size * 0.58},
			rl.BROWN,
			rl.DARKGREEN,
		)
		trees.draw_oak(
			rl.Vector3{position.x + tile_size * 0.18, position.y, position.z - tile_size * 0.16},
			rl.Vector3{tile_size * 0.54, tile_size * 1.25, tile_size * 0.54},
			rl.BROWN,
			rl.GREEN,
		)
	case .Mountain:
		mountains.draw_mountain(
			position,
			rl.Vector3{tile_size * 1.1, tile_size * 1.6, tile_size * 1.1},
			rl.DARKGRAY,
		)
	case .Ridge:
		mountains.draw_mountain(
			position,
			rl.Vector3{tile_size * 1.0, tile_size * 0.8, tile_size * 0.8},
			rl.GRAY,
		)
	case .Dune:
		draw_dune(position, tile_size)
	case .Enemy_Outpost:
		draw_enemy_outpost(position, tile_size)
	case .Drone_Launch:
		draw_drone_launch(position, tile_size)
	case .Grass, .Sand, .Shore, .Shallow_Water, .Deep_Water:
	}

	if options.show_cover && tile_has_cover(tile) {
		draw_cover_ring(position, tile_size)
	}
}

draw_tile_blocks :: proc(
	field: ^Field_Map,
	tile_x: int,
	tile_z: int,
	tile: Map_Tile,
	position: rl.Vector3,
	options: Field_Draw_Options,
) {
	profile := tile_profile(tile)
	tile_size := field.tile_size
	block_size := tile_size / f32(TILE_BLOCKS_PER_AXIS)
	first_offset := -tile_size * 0.5 + block_size * 0.5
	block_dimensions := rl.Vector3{block_size, block_size, block_size}

	for level := 0; level < TILE_BLOCKS_PER_AXIS; level += 1 {
		block_level := profile.levels[level]
		if block_level.color.a == 0 {
			continue
		}

		for z := 0; z < TILE_BLOCKS_PER_AXIS; z += 1 {
			for x := 0; x < TILE_BLOCKS_PER_AXIS; x += 1 {
				point := Map_Block_Point{tile_x = tile_x, tile_z = tile_z, block_x = x, level = level, block_z = z}
				removed_index, removed_inside := map_tile_block_index(field, point)
				if removed_inside && removed_index < len(options.removed_blocks) && options.removed_blocks[removed_index] {
					continue
				}

				block_position := rl.Vector3 {
					position.x + first_offset + f32(x) * block_size,
					position.y - block_size * 0.5 - f32(level) * block_size,
					position.z + first_offset + f32(z) * block_size,
				}
				rl.DrawCubeV(block_position, block_dimensions, block_level.color)
				if options.show_grid {
					rl.DrawCubeWiresV(block_position, block_dimensions, rl.ColorAlpha(rl.DARKGRAY, 0.42))
				}
			}
		}
	}

	if options.show_grid {
		tile_body := rl.Vector3{tile_size, tile_size, tile_size}
		tile_center := rl.Vector3{position.x, position.y - tile_size * 0.5, position.z}
		rl.DrawCubeWiresV(tile_center, tile_body, rl.DARKGRAY)
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
	case .Shallow_Water:
		return SHALLOW_WATER
	case .Deep_Water:
		return DEEP_WATER
	case .Shore:
		return SHORE
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
	rl.DrawCubeV(
		rl.Vector3{position.x - tile_size * 0.22, tile_size * 0.14, position.z},
		blade_size,
		TALL_GRASS,
	)
	rl.DrawCubeV(
		rl.Vector3{position.x, tile_size * 0.16, position.z - tile_size * 0.20},
		blade_size,
		TALL_GRASS,
	)
	rl.DrawCubeV(
		rl.Vector3{position.x + tile_size * 0.24, tile_size * 0.13, position.z + tile_size * 0.18},
		blade_size,
		TALL_GRASS,
	)
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
	drones.draw_quadcopter(
		rl.Vector3{position.x, tile_size * 0.62, position.z},
		rl.Vector3{tile_size * 0.72, tile_size * 0.38, tile_size * 0.72},
		rl.LIGHTGRAY,
	)
}

draw_cover_ring :: proc(position: rl.Vector3, tile_size: f32) {
	rl.DrawCubeWiresV(
		rl.Vector3{position.x, tile_size * 0.03, position.z},
		rl.Vector3{tile_size * 0.92, tile_size * 0.06, tile_size * 0.92},
		rl.DARKGREEN,
	)
}

draw_player_marker :: proc(position: rl.Vector3, tile_size: f32) {
	body_size := rl.Vector3{tile_size * 0.22, tile_size * 0.46, tile_size * 0.22}
	body_position := rl.Vector3{position.x, tile_size * 0.23, position.z}
	rl.DrawCubeV(body_position, body_size, PLAYER_COLOR)
	rl.DrawCubeWiresV(body_position, body_size, rl.RAYWHITE)
}
