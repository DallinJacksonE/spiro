package scenes

import rl "vendor:raylib"

STUDIO_NAME :: "Melisapis"
STUDIO_INTRO_FADE_SECONDS :: f32(1.25)
STUDIO_INTRO_HOLD_SECONDS :: f32(0.75)

Studio_Intro_Phase :: enum {
	Fade_In,
	Hold,
	Fade_Out,
	Complete,
}

Studio_Intro_Scene :: struct {
	phase:   Studio_Intro_Phase,
	elapsed: f32,
}

studio_intro_scene_init :: proc() -> Studio_Intro_Scene {
	return {phase = .Fade_In, elapsed = 0}
}

update_studio_intro_scene :: proc(scene: ^Studio_Intro_Scene, dt: f32) -> Scene_Result {
	if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.SPACE) {
		scene.phase = .Complete
		return .Complete
	}

	scene.elapsed += dt

	switch scene.phase {
	case .Fade_In:
		if scene.elapsed >= STUDIO_INTRO_FADE_SECONDS {
			advance_studio_intro_phase(scene, .Hold)
		}
	case .Hold:
		if scene.elapsed >= STUDIO_INTRO_HOLD_SECONDS {
			advance_studio_intro_phase(scene, .Fade_Out)
		}
	case .Fade_Out:
		if scene.elapsed >= STUDIO_INTRO_FADE_SECONDS {
			advance_studio_intro_phase(scene, .Complete)
		}
	case .Complete:
		return .Complete
	}

	return scene.phase == .Complete ? .Complete : .Running
}

draw_studio_intro_scene :: proc(scene: ^Studio_Intro_Scene) {
	font_size := i32(64)
	text_width := rl.MeasureText(STUDIO_NAME, font_size)
	screen_width := rl.GetScreenWidth()
	screen_height := rl.GetScreenHeight()
	x := (screen_width - text_width) / 2
	y := (screen_height - font_size) / 2
	color := rl.ColorAlpha(rl.RAYWHITE, studio_intro_alpha(scene))

	rl.DrawText(STUDIO_NAME, x, y, font_size, color)
}
draw_placeholder_scene :: proc(message: cstring) {
	draw_centered_text(message, 32, 0, rl.RAYWHITE)
}

advance_studio_intro_phase :: proc(scene: ^Studio_Intro_Scene, next: Studio_Intro_Phase) {
	scene.phase = next
	scene.elapsed = 0
}

studio_intro_alpha :: proc(scene: ^Studio_Intro_Scene) -> f32 {
	switch scene.phase {
	case .Fade_In:
		return clamp01(scene.elapsed / STUDIO_INTRO_FADE_SECONDS)
	case .Hold:
		return 1
	case .Fade_Out:
		return 1 - clamp01(scene.elapsed / STUDIO_INTRO_FADE_SECONDS)
	case .Complete:
		return 0
	}

	return 0
}

