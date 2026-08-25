package scenes

import rl "vendor:raylib"

Scene_Result :: enum {
	Running,
	Complete,
}

Screen_Shake :: struct {
	duration:  f32,
	strength:  f32,
	frequency: f32,
}

draw_centered_text :: proc(text: cstring, font_size: i32, y_offset: i32, color: rl.Color) {
	text_width := rl.MeasureText(text, font_size)
	screen_width := rl.GetScreenWidth()
	screen_height := rl.GetScreenHeight()
	x := (screen_width - text_width) / 2
	y := (screen_height - font_size) / 2 + y_offset

	rl.DrawText(text, x, y, font_size, color)
}

clamp01 :: proc(value: f32) -> f32 {
	if value < 0 {
		return 0
	}

	if value > 1 {
		return 1
	}

	return value
}

lerp_f32 :: proc(start, end, amount: f32) -> f32 {
	return start + (end - start) * amount
}

lerp_vector3 :: proc(start, end: rl.Vector3, amount: f32) -> rl.Vector3 {
	return rl.Vector3 {
		lerp_f32(start.x, end.x, amount),
		lerp_f32(start.y, end.y, amount),
		lerp_f32(start.z, end.z, amount),
	}
}

screen_shake_offset :: proc(shake: Screen_Shake, elapsed: f32) -> rl.Vector3 {
	if shake.duration <= 0 || shake.strength <= 0 || elapsed < 0 || elapsed > shake.duration {
		return rl.Vector3{0, 0, 0}
	}

	fade := 1 - clamp01(elapsed / shake.duration)
	amount := shake.strength * fade
	x := pseudo_wave(elapsed * shake.frequency + 0.13) * amount
	y := pseudo_wave(elapsed * shake.frequency + 1.71) * amount * 0.5
	z := pseudo_wave(elapsed * shake.frequency + 2.37) * amount

	return rl.Vector3{x, y, z}
}

pseudo_wave :: proc(value: f32) -> f32 {
	whole := i32(value * 1000)
	mixed := (whole * 1103515245 + 12345) & 0x7fffffff
	unit := f32(mixed % 2000) / 1000.0
	return unit - 1
}
