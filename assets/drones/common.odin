package drones

import rl "vendor:raylib"

add_vector3 :: proc(a, b: rl.Vector3) -> rl.Vector3 {
	return rl.Vector3{a.x + b.x, a.y + b.y, a.z + b.z}
}
