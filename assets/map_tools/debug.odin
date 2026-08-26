package map_tools

import rl "vendor:raylib"

Hovered_Tile :: struct {
	point:    Map_Point,
	tile:     Map_Tile,
	position: rl.Vector3,
	inside:   bool,
}

hovered_tile_from_cursor :: proc(field: ^Field_Map, camera: rl.Camera3D) -> Hovered_Tile {
	mouse := rl.GetMousePosition()
	ray := rl.GetScreenToWorldRay(mouse, camera)

	if ray.direction.y == 0 {
		return Hovered_Tile{}
	}

	amount := -ray.position.y / ray.direction.y
	if amount < 0 {
		return Hovered_Tile{}
	}

	world := rl.Vector3 {
		ray.position.x + ray.direction.x * amount,
		0,
		ray.position.z + ray.direction.z * amount,
	}
	point, inside := world_to_tile(field, world)

	if !inside {
		return Hovered_Tile{position = world, inside = false}
	}

	return Hovered_Tile {
		point = point,
		tile = map_tile_at(field, point.x, point.z),
		position = tile_world_position(field, point.x, point.z),
		inside = true,
	}
}

world_to_tile :: proc(field: ^Field_Map, world: rl.Vector3) -> (Map_Point, bool) {
	half_width := f32(field.width - 1) * field.tile_size * 0.5
	half_height := f32(field.height - 1) * field.tile_size * 0.5
	x := int((world.x + half_width + field.tile_size * 0.5) / field.tile_size)
	z := int((world.z + half_height + field.tile_size * 0.5) / field.tile_size)

	if x < 0 || z < 0 || x >= field.width || z >= field.height {
		return Map_Point{}, false
	}

	return Map_Point{x = x, z = z}, true
}

draw_hovered_tile_marker :: proc(field: ^Field_Map, hovered: Hovered_Tile) {
	if !hovered.inside {
		return
	}

	rl.DrawCubeWiresV(
		rl.Vector3{hovered.position.x, 0.08, hovered.position.z},
		rl.Vector3{field.tile_size, 0.16, field.tile_size},
		rl.YELLOW,
	)
}

draw_hovered_tile_panel :: proc(hovered: Hovered_Tile) {
	if !hovered.inside {
		return
	}

	mouse := rl.GetMousePosition()
	x := i32(mouse.x) + 18
	y := i32(mouse.y) + 18
	panel_width := i32(190)
	panel_height := i32(128)

	rl.DrawRectangle(x, y, panel_width, panel_height, rl.ColorAlpha(rl.BLACK, 0.72))
	rl.DrawRectangleLines(x, y, panel_width, panel_height, rl.YELLOW)
	rl.DrawText("Tile", x + 10, y + 8, 18, rl.LIGHTGRAY)
	rl.DrawText(tile_name(hovered.tile), x + 10, y + 30, 20, rl.RAYWHITE)
	rl.DrawText(tile_cover_label(hovered.tile), x + 10, y + 56, 16, rl.GREEN)
	rl.DrawText(tile_block_count_label(hovered.tile), x + 10, y + 78, 16, rl.LIGHTGRAY)
	rl.DrawText(tile_surface_label(hovered.tile), x + 10, y + 100, 16, rl.LIGHTGRAY)
}

tile_name :: proc(tile: Map_Tile) -> cstring {
	switch tile {
	case .Empty:
		return "Empty"
	case .Grass:
		return "Grass"
	case .Tall_Grass:
		return "Tall Grass"
	case .Forest:
		return "Forest"
	case .Dense_Forest:
		return "Dense Forest"
	case .Mountain:
		return "Mountain"
	case .Ridge:
		return "Ridge"
	case .Sand:
		return "Sand"
	case .Dune:
		return "Dune"
	case .Shore:
		return "Shore"
	case .Shallow_Water:
		return "Shallow_Water"
	case .Deep_Water:
		return "Deep_Water"
	case .Enemy_Outpost:
		return "Enemy Outpost"
	case .Drone_Launch:
		return "Drone Launch"
	}

	return "Unknown"
}

tile_cover_label :: proc(tile: Map_Tile) -> cstring {
	if tile_has_cover(tile) {
		return "Cover: yes"
	}

	return "Cover: no"
}

tile_block_count_label :: proc(tile: Map_Tile) -> cstring {
	if tile == .Empty {
		return "Blocks: 0"
	}

	return "Blocks: 125 (5x5x5)"
}

tile_surface_label :: proc(tile: Map_Tile) -> cstring {
	level := tile_block_level(tile, 0)
	if level.attributes.falls_without_support {
		return "Top: falls if unsupported"
	}
	if level.attributes.tunnelable {
		return "Top: stable tunnel material"
	}

	return "Top: solid"
}
