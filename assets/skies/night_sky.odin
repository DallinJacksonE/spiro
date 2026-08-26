package skies

import rl "vendor:raylib"

add_vector3 :: proc(a, b: rl.Vector3) -> rl.Vector3 {
	return rl.Vector3{a.x + b.x, a.y + b.y, a.z + b.z}
}

draw_night_sky :: proc(position, size: rl.Vector3, color: rl.Color) {
	backdrop_size := rl.Vector3{size.x, size.y, size.z * 0.06}
	rl.DrawCubeV(position, backdrop_size, color)

	draw_moon(add_vector3(position, rl.Vector3{size.x * 0.32, size.y * 0.24, -size.z * 0.04}), size.y * 0.08)
	draw_star(add_vector3(position, rl.Vector3{-size.x * 0.42, size.y * 0.32, -size.z * 0.08}), size.y * 0.018)
	draw_star(add_vector3(position, rl.Vector3{-size.x * 0.28, size.y * 0.12, -size.z * 0.08}), size.y * 0.012)
	draw_star(add_vector3(position, rl.Vector3{-size.x * 0.12, size.y * 0.36, -size.z * 0.08}), size.y * 0.015)
	draw_star(add_vector3(position, rl.Vector3{size.x * 0.04, size.y * 0.20, -size.z * 0.08}), size.y * 0.011)
	draw_star(add_vector3(position, rl.Vector3{size.x * 0.18, size.y * 0.40, -size.z * 0.08}), size.y * 0.014)
	draw_star(add_vector3(position, rl.Vector3{size.x * 0.42, size.y * 0.06, -size.z * 0.08}), size.y * 0.012)
	draw_star(add_vector3(position, rl.Vector3{size.x * 0.12, -size.y * 0.02, -size.z * 0.08}), size.y * 0.010)
}

draw_moon :: proc(position: rl.Vector3, radius: f32) {
	moon_size := rl.Vector3{radius, radius, radius * 0.18}
	rl.DrawCubeV(position, moon_size, rl.LIGHTGRAY)
	rl.DrawCubeWiresV(position, moon_size, rl.RAYWHITE)
}

draw_star :: proc(position: rl.Vector3, radius: f32) {
	star_size := rl.Vector3{radius, radius, radius * 0.20}
	rl.DrawCubeV(position, star_size, rl.RAYWHITE)
}
