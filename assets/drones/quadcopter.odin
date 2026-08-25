package drones

import rl "vendor:raylib"

draw_quadcopter :: proc(position, size: rl.Vector3, color: rl.Color) {
	body_size := rl.Vector3{size.x * 0.32, size.y * 0.22, size.z * 0.32}
	arm_x_size := rl.Vector3{size.x, size.y * 0.08, size.z * 0.08}
	arm_z_size := rl.Vector3{size.x * 0.08, size.y * 0.08, size.z}
	rotor_size := rl.Vector3{size.x * 0.22, size.y * 0.03, size.z * 0.22}

	rl.DrawCubeV(position, body_size, color)
	rl.DrawCubeWiresV(position, body_size, rl.RAYWHITE)
	rl.DrawCubeV(position, arm_x_size, rl.GRAY)
	rl.DrawCubeV(position, arm_z_size, rl.GRAY)

	draw_rotor(add_vector3(position, rl.Vector3{-size.x * 0.45, 0, -size.z * 0.45}), rotor_size)
	draw_rotor(add_vector3(position, rl.Vector3{size.x * 0.45, 0, -size.z * 0.45}), rotor_size)
	draw_rotor(add_vector3(position, rl.Vector3{-size.x * 0.45, 0, size.z * 0.45}), rotor_size)
	draw_rotor(add_vector3(position, rl.Vector3{size.x * 0.45, 0, size.z * 0.45}), rotor_size)
}

draw_rotor :: proc(position, size: rl.Vector3) {
	rl.DrawCubeV(position, size, rl.DARKGRAY)
	rl.DrawCubeWiresV(position, size, rl.RAYWHITE)
}


