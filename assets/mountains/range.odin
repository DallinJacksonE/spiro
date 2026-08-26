package mountains

import rl "vendor:raylib"

add_vector3 :: proc(a, b: rl.Vector3) -> rl.Vector3 {
	return rl.Vector3{a.x + b.x, a.y + b.y, a.z + b.z}
}

draw_mountain_range :: proc(position, size: rl.Vector3, color: rl.Color) {
	draw_mountain(add_vector3(position, rl.Vector3{-size.x * 0.34, 0, 0}), rl.Vector3{size.x * 0.34, size.y * 0.92, size.z}, color)
	draw_mountain(add_vector3(position, rl.Vector3{-size.x * 0.10, 0, -size.z * 0.04}), rl.Vector3{size.x * 0.44, size.y * 1.12, size.z * 1.05}, rl.DARKGRAY)
	draw_mountain(add_vector3(position, rl.Vector3{size.x * 0.18, 0, 0}), rl.Vector3{size.x * 0.34, size.y * 0.78, size.z}, color)
	draw_mountain(add_vector3(position, rl.Vector3{size.x * 0.40, 0, -size.z * 0.02}), rl.Vector3{size.x * 0.26, size.y * 0.66, size.z * 0.88}, rl.GRAY)
}

draw_mountain :: proc(position, size: rl.Vector3, color: rl.Color) {
	base := add_vector3(position, rl.Vector3{0, size.y * 0.16, 0})
	mid := add_vector3(position, rl.Vector3{0, size.y * 0.45, 0})
	peak := add_vector3(position, rl.Vector3{0, size.y * 0.72, 0})

	rl.DrawCubeV(base, rl.Vector3{size.x, size.y * 0.32, size.z}, color)
	rl.DrawCubeWiresV(base, rl.Vector3{size.x, size.y * 0.32, size.z}, rl.DARKGRAY)
	rl.DrawCubeV(mid, rl.Vector3{size.x * 0.66, size.y * 0.30, size.z * 0.72}, color)
	rl.DrawCubeWiresV(mid, rl.Vector3{size.x * 0.66, size.y * 0.30, size.z * 0.72}, rl.DARKGRAY)
	rl.DrawCubeV(peak, rl.Vector3{size.x * 0.32, size.y * 0.24, size.z * 0.40}, rl.LIGHTGRAY)
	rl.DrawCubeWiresV(peak, rl.Vector3{size.x * 0.32, size.y * 0.24, size.z * 0.40}, rl.RAYWHITE)
}
