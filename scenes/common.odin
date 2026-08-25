package scenes

import rl "vendor:raylib"

Scene_Result :: enum {
	Running,
	Complete,
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