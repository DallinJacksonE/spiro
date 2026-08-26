package map_tools

import rl "vendor:raylib"

TILE_BLOCKS_PER_AXIS :: 5
TILE_BLOCK_COUNT :: TILE_BLOCKS_PER_AXIS * TILE_BLOCKS_PER_AXIS * TILE_BLOCKS_PER_AXIS

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
	Shore,
	Shallow_Water,
	Deep_Water,
}

Map_Point :: struct {
	x: int,
	z: int,
}

Map_Block_Attributes :: struct {
	// Unsupported blocks with this flag collapse when future digging removes the block beneath them.
	falls_without_support: bool,
	// Tunnelable blocks can be removed by digging. Stable tunnelable blocks allow horizontal tunnels.
	tunnelable:            bool,
}

Map_Block_Level :: struct {
	color:      rl.Color,
	attributes: Map_Block_Attributes,
}

Map_Tile_Profile :: struct {
	// Level 0 is the exposed top layer. Higher indices move downward into the tile.
	levels: [TILE_BLOCKS_PER_AXIS]Map_Block_Level,
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

Map_Block_Point :: struct {
	tile_x:  int,
	tile_z:  int,
	block_x: int,
	level:   int,
	block_z: int,
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

tile_profile :: proc(tile: Map_Tile) -> Map_Tile_Profile {
	switch tile {
	case .Empty:
		return tile_profile_solid(rl.ColorAlpha(rl.BLACK, 0), false, false)
	case .Grass, .Tall_Grass, .Forest, .Dense_Forest, .Enemy_Outpost, .Drone_Launch:
		return Map_Tile_Profile {
			levels = [TILE_BLOCKS_PER_AXIS]Map_Block_Level {
				block_level(PLAINS_GROUND, true, true),
				block_level(SANDY_DIRT, true, true),
				block_level(SANDY_DIRT, true, true),
				block_level(DARK_CLAY, false, true),
				block_level(DARK_CLAY, false, true),
			},
		}
	case .Mountain, .Ridge:
		return tile_profile_solid(MOUNTAIN_GROUND, false, false)
	case .Sand, .Dune, .Shore:
		return tile_profile_solid(DESERT_GROUND, true, true)
	case .Shallow_Water:
		return tile_profile_solid(SHALLOW_WATER, false, false)
	case .Deep_Water:
		return tile_profile_solid(DEEP_WATER, false, false)
	}

	return tile_profile_solid(PLAINS_GROUND, false, false)
}

tile_block_level :: proc(tile: Map_Tile, level: int) -> Map_Block_Level {
	profile := tile_profile(tile)
	if level < 0 || level >= TILE_BLOCKS_PER_AXIS {
		return Map_Block_Level{}
	}

	return profile.levels[level]
}

map_tile_block_index :: proc(field: ^Field_Map, point: Map_Block_Point) -> (int, bool) {
	if point.tile_x < 0 || point.tile_z < 0 || point.tile_x >= field.width || point.tile_z >= field.height {
		return -1, false
	}
	if point.block_x < 0 || point.block_z < 0 || point.level < 0 {
		return -1, false
	}
	if point.block_x >= TILE_BLOCKS_PER_AXIS || point.block_z >= TILE_BLOCKS_PER_AXIS || point.level >= TILE_BLOCKS_PER_AXIS {
		return -1, false
	}

	tile_index := point.tile_z * field.width + point.tile_x
	block_index := point.level * TILE_BLOCKS_PER_AXIS * TILE_BLOCKS_PER_AXIS + point.block_z * TILE_BLOCKS_PER_AXIS + point.block_x
	return tile_index * TILE_BLOCK_COUNT + block_index, true
}

map_tile_block_world_position :: proc(field: ^Field_Map, point: Map_Block_Point) -> rl.Vector3 {
	tile_position := tile_world_position(field, point.tile_x, point.tile_z)
	block_size := field.tile_size / f32(TILE_BLOCKS_PER_AXIS)
	first_offset := -field.tile_size * 0.5 + block_size * 0.5

	return rl.Vector3 {
		tile_position.x + first_offset + f32(point.block_x) * block_size,
		tile_position.y - block_size * 0.5 - f32(point.level) * block_size,
		tile_position.z + first_offset + f32(point.block_z) * block_size,
	}
}

tile_level_can_tunnel :: proc(tile: Map_Tile, level: int) -> bool {
	return tile_block_level(tile, level).attributes.tunnelable
}

tile_level_falls_without_support :: proc(tile: Map_Tile, level: int) -> bool {
	return tile_block_level(tile, level).attributes.falls_without_support
}

tile_profile_solid :: proc(
	color: rl.Color,
	falls_without_support: bool,
	tunnelable: bool,
) -> Map_Tile_Profile {
	level := block_level(color, falls_without_support, tunnelable)
	return Map_Tile_Profile {
		levels = [TILE_BLOCKS_PER_AXIS]Map_Block_Level{level, level, level, level, level},
	}
}

block_level :: proc(color: rl.Color, falls_without_support, tunnelable: bool) -> Map_Block_Level {
	return Map_Block_Level {
		color = color,
		attributes = Map_Block_Attributes {
			falls_without_support = falls_without_support,
			tunnelable = tunnelable,
		},
	}
}

tile_has_cover :: proc(tile: Map_Tile) -> bool {
	switch tile {
	case .Tall_Grass, .Forest, .Dense_Forest, .Mountain, .Ridge, .Dune:
		return true
	case .Empty, .Grass, .Sand, .Enemy_Outpost, .Drone_Launch, .Shore, .Shallow_Water, .Deep_Water:
		return false
	}

	return false
}

tile_blocks_walking :: proc(tile: Map_Tile) -> bool {
	switch tile {
	case .Mountain, .Deep_Water:
		return true
	case .Empty,
	     .Grass,
	     .Tall_Grass,
	     .Forest,
	     .Dense_Forest,
	     .Ridge,
	     .Sand,
	     .Dune,
	     .Enemy_Outpost,
	     .Shore,
	     .Shallow_Water,
	     .Drone_Launch:
		return false
	}

	return false
}

tile_world_position :: proc(field: ^Field_Map, x, z: int) -> rl.Vector3 {
	half_width := f32(field.width - 1) * field.tile_size * 0.5
	half_height := f32(field.height - 1) * field.tile_size * 0.5
	return rl.Vector3 {
		f32(x) * field.tile_size - half_width,
		0,
		f32(z) * field.tile_size - half_height,
	}
}

map_world_bounds :: proc(field: ^Field_Map) -> rl.Vector3 {
	return rl.Vector3{f32(field.width) * field.tile_size, 0, f32(field.height) * field.tile_size}
}
