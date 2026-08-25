package scenes

import rl "vendor:raylib"

MAIN_MENU_FADE_SECONDS :: f32(0.65)

Main_Menu_Phase :: enum {
	Fade_In,
	Ready,
	Fade_Out,
	Complete,
}

Main_Menu_Scene :: struct {
	phase:   Main_Menu_Phase,
	elapsed: f32,
}

main_menu_scene_init :: proc() -> Main_Menu_Scene {
	return {phase = .Fade_In, elapsed = 0}
}

update_main_menu_scene :: proc(scene: ^Main_Menu_Scene, dt: f32) -> Scene_Result {
	scene.elapsed += dt

	switch scene.phase {
	case .Fade_In:
		if scene.elapsed >= MAIN_MENU_FADE_SECONDS {
			advance_main_menu_phase(scene, .Ready)
		}
	case .Ready:
		if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.SPACE) {
			advance_main_menu_phase(scene, .Fade_Out)
		}
	case .Fade_Out:
		if scene.elapsed >= MAIN_MENU_FADE_SECONDS {
			advance_main_menu_phase(scene, .Complete)
		}
	case .Complete:
		return .Complete
	}

	return scene.phase == .Complete ? .Complete : .Running
}

draw_main_menu_scene :: proc(scene: ^Main_Menu_Scene) {
	alpha := main_menu_alpha(scene)
	primary := rl.ColorAlpha(rl.RAYWHITE, alpha)
	secondary := rl.ColorAlpha(rl.GRAY, alpha)

	draw_centered_text("Spiro", 56, -24, primary)
	draw_centered_text("Press Enter to start", 24, 48, secondary)
	draw_centered_text("Press Esc to quit", 24, 78, secondary)
}

advance_main_menu_phase :: proc(scene: ^Main_Menu_Scene, next: Main_Menu_Phase) {
	scene.phase = next
	scene.elapsed = 0
}

main_menu_alpha :: proc(scene: ^Main_Menu_Scene) -> f32 {
	switch scene.phase {
	case .Fade_In:
		return clamp01(scene.elapsed / MAIN_MENU_FADE_SECONDS)
	case .Ready:
		return 1
	case .Fade_Out:
		return 1 - clamp01(scene.elapsed / MAIN_MENU_FADE_SECONDS)
	case .Complete:
		return 0
	}

	return 0
}
