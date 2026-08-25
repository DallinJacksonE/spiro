package trees

import rl "vendor:raylib"

draw_oak :: proc(position, size: rl.Vector3, trunk_color, leaf_color: rl.Color) {
	trunk_size := rl.Vector3{size.x * 0.28, size.y * 0.62, size.z * 0.28}
	trunk_position := add_vector3(position, rl.Vector3{0, trunk_size.y * 0.5, 0})
	rl.DrawCubeV(trunk_position, trunk_size, trunk_color)
	rl.DrawCubeWiresV(trunk_position, trunk_size, rl.RAYWHITE)

	canopy_size := rl.Vector3{size.x, size.y * 0.48, size.z}
	canopy_position := add_vector3(position, rl.Vector3{0, size.y * 0.92, 0})
	rl.DrawCubeV(canopy_position, canopy_size, leaf_color)
	rl.DrawCubeWiresV(canopy_position, canopy_size, rl.DARKGREEN)

	left_lobe := add_vector3(canopy_position, rl.Vector3{-size.x * 0.32, -size.y * 0.05, 0})
	right_lobe := add_vector3(canopy_position, rl.Vector3{size.x * 0.32, -size.y * 0.05, 0})
	lobe_size := rl.Vector3{size.x * 0.52, size.y * 0.34, size.z * 0.72}
	rl.DrawCubeV(left_lobe, lobe_size, leaf_color)
	rl.DrawCubeV(right_lobe, lobe_size, leaf_color)
}


