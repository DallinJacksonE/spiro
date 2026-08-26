package map_tools

import rl "vendor:raylib"

Map_Biome :: enum {
	Forest,
	Plains,
	Mountains,
	Desert,
}

Map_Tile :: enum {
	Empty,
	Grass,
	Tall_Grass,
	Forest,
	Dense_Forest,
	Mountain,
	Ridge,
	Sand,
	Dune,
	Enemy_Outpost,
	Drone_Launch,
}

Map_Point :: struct {
	x: int,
	z: int,
}

Field_Map :: struct {
	name:         cstring,
	biome:        Map_Biome,
	width:        int,
	height:       int,
	tile_size:    f32,
	tiles:        []Map_Tile,
	player_start: Map_Point,
}

Map_Query :: struct {
	position: rl.Vector3,
	tile:     Map_Tile,
	inside:   bool,
}

map_tile_at :: proc(field: ^Field_Map, x, z: int) -> Map_Tile {
	if x < 0 || z < 0 || x >= field.width || z >= field.height {
		return .Empty
	}

	index := z * field.width + x
	if index < 0 || index >= len(field.tiles) {
		return .Empty
	}

	return field.tiles[index]
}

tile_has_cover :: proc(tile: Map_Tile) -> bool {
	switch tile {
	case .Tall_Grass, .Forest, .Dense_Forest, .Mountain, .Ridge, .Dune:
		return true
	case .Empty, .Grass, .Sand, .Enemy_Outpost, .Drone_Launch:
		return false
	}

	return false
}

tile_blocks_walking :: proc(tile: Map_Tile) -> bool {
	switch tile {
	case .Mountain:
		return true
	case .Empty, .Grass, .Tall_Grass, .Forest, .Dense_Forest, .Ridge, .Sand, .Dune, .Enemy_Outpost, .Drone_Launch:
		return false
	}

	return false
}

tile_world_position :: proc(field: ^Field_Map, x, z: int) -> rl.Vector3 {
	half_width := f32(field.width - 1) * field.tile_size * 0.5
	half_height := f32(field.height - 1) * field.tile_size * 0.5
	return rl.Vector3{f32(x) * field.tile_size - half_width, 0, f32(z) * field.tile_size - half_height}
}

map_world_bounds :: proc(field: ^Field_Map) -> rl.Vector3 {
	return rl.Vector3{f32(field.width) * field.tile_size, 0, f32(field.height) * field.tile_size}
}
