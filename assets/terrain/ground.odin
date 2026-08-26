package terrain

import rl "vendor:raylib"

add_vector3 :: proc(a, b: rl.Vector3) -> rl.Vector3 {
	return rl.Vector3{a.x + b.x, a.y + b.y, a.z + b.z}
}

draw_ground_patch :: proc(position, size: rl.Vector3, color: rl.Color) {
	ground_position := add_vector3(position, rl.Vector3{0, -size.y * 0.5, 0})
	rl.DrawCubeV(ground_position, size, color)
	rl.DrawCubeWiresV(ground_position, size, rl.DARKGREEN)

	draw_low_ridge(add_vector3(position, rl.Vector3{-size.x * 0.28, size.y * 0.08, -size.z * 0.12}), rl.Vector3{size.x * 0.32, size.y * 0.45, size.z * 0.10}, rl.BROWN)
	draw_low_ridge(add_vector3(position, rl.Vector3{size.x * 0.22, size.y * 0.06, size.z * 0.18}), rl.Vector3{size.x * 0.24, size.y * 0.34, size.z * 0.08}, rl.DARKBROWN)
	draw_rock(add_vector3(position, rl.Vector3{-size.x * 0.40, size.y * 0.16, size.z * 0.30}), size.x * 0.035)
	draw_rock(add_vector3(position, rl.Vector3{size.x * 0.36, size.y * 0.14, -size.z * 0.34}), size.x * 0.028)
	draw_rock(add_vector3(position, rl.Vector3{size.x * 0.08, size.y * 0.15, size.z * 0.40}), size.x * 0.025)
}

draw_low_ridge :: proc(position, size: rl.Vector3, color: rl.Color) {
	rl.DrawCubeV(position, size, color)
	rl.DrawCubeWiresV(position, size, rl.DARKGRAY)
}

draw_rock :: proc(position: rl.Vector3, radius: f32) {
	rock_size := rl.Vector3{radius * 1.4, radius * 0.8, radius}
	rl.DrawCubeV(position, rock_size, rl.GRAY)
	rl.DrawCubeWiresV(position, rock_size, rl.LIGHTGRAY)
}
