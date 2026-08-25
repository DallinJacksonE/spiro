package trees

import rl "vendor:raylib"

draw_pine :: proc(position, size: rl.Vector3, trunk_color, leaf_color: rl.Color) {
	trunk_size := rl.Vector3{size.x * 0.22, size.y * 0.55, size.z * 0.22}
	trunk_position := add_vector3(position, rl.Vector3{0, trunk_size.y * 0.5, 0})
	rl.DrawCubeV(trunk_position, trunk_size, trunk_color)
	rl.DrawCubeWiresV(trunk_position, trunk_size, rl.RAYWHITE)

	lower_size := rl.Vector3{size.x, size.y * 0.38, size.z}
	middle_size := rl.Vector3{size.x * 0.72, size.y * 0.34, size.z * 0.72}
	upper_size := rl.Vector3{size.x * 0.45, size.y * 0.30, size.z * 0.45}

	draw_leaf_block(add_vector3(position, rl.Vector3{0, size.y * 0.62, 0}), lower_size, leaf_color)
	draw_leaf_block(add_vector3(position, rl.Vector3{0, size.y * 0.88, 0}), middle_size, leaf_color)
	draw_leaf_block(add_vector3(position, rl.Vector3{0, size.y * 1.12, 0}), upper_size, leaf_color)
}

draw_leaf_block :: proc(position, size: rl.Vector3, color: rl.Color) {
	rl.DrawCubeV(position, size, color)
	rl.DrawCubeWiresV(position, size, rl.DARKGREEN)
}


