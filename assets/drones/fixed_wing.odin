package drones

import rl "vendor:raylib"

draw_fixed_wing :: proc(position, size: rl.Vector3, color: rl.Color) {
	fuselage_size := rl.Vector3{size.x * 0.22, size.y * 0.22, size.z}
	wing_size := rl.Vector3{size.x, size.y * 0.08, size.z * 0.28}
	tail_wing_size := rl.Vector3{size.x * 0.42, size.y * 0.07, size.z * 0.18}
	payload_size := rl.Vector3{size.x * 0.16, size.y * 0.28, size.z * 0.16}

	rl.DrawCubeV(position, fuselage_size, color)
	rl.DrawCubeWiresV(position, fuselage_size, rl.RAYWHITE)

	wing_position := add_vector3(position, rl.Vector3{0, size.y * 0.04, -size.z * 0.05})
	rl.DrawCubeV(wing_position, wing_size, color)
	rl.DrawCubeWiresV(wing_position, wing_size, rl.RAYWHITE)

	tail_position := add_vector3(position, rl.Vector3{0, size.y * 0.06, size.z * 0.38})
	rl.DrawCubeV(tail_position, tail_wing_size, rl.GRAY)
	rl.DrawCubeWiresV(tail_position, tail_wing_size, rl.RAYWHITE)

	payload_position := add_vector3(position, rl.Vector3{0, -size.y * 0.32, -size.z * 0.05})
	rl.DrawCubeV(payload_position, payload_size, rl.MAROON)
	rl.DrawCubeWiresV(payload_position, payload_size, rl.RED)

	left_light := add_vector3(position, rl.Vector3{-size.x * 0.45, size.y * 0.12, -size.z * 0.05})
	right_light := add_vector3(position, rl.Vector3{size.x * 0.45, size.y * 0.12, -size.z * 0.05})
	draw_signal_light(left_light, size)
	draw_signal_light(right_light, size)
}

draw_signal_light :: proc(position, parent_size: rl.Vector3) {
	light_size := rl.Vector3{parent_size.x * 0.08, parent_size.y * 0.12, parent_size.z * 0.08}
	rl.DrawCubeV(position, light_size, rl.RED)
}


