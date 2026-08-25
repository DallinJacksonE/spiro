package scenes

import drones "../assets/drones"
import rl "vendor:raylib"
import trees "../assets/trees"

Cutscene :: struct {
	result:       Scene_Result,
	shots:        []Scene_Shot,
	current:      int,
	shot_elapsed: f32,
}

Scene_Shot :: struct {
	length:         f32,
	camera_start:   rl.Vector3,
	camera_end:     rl.Vector3,
	target_start:   rl.Vector3,
	target_end:     rl.Vector3,
	up:             rl.Vector3,
	background:     rl.Color,
	show_grid:      bool,
	fade_to_black:  bool,
	shake_delay:    f32,
	shake:          Screen_Shake,
	title:          cstring,
	subtitles:      []cstring,
	drawables:      []Cutscene_Drawable,
}

Cutscene_Asset :: enum {
	Primitive_Cube,
	Fixed_Wing_Drone,
	Quadcopter,
	Pine_Tree,
	Oak_Tree,
}

Cutscene_Drawable :: struct {
	asset:          Cutscene_Asset,
	position_start: rl.Vector3,
	position_end:   rl.Vector3,
	size_start:     rl.Vector3,
	size_end:       rl.Vector3,
	color:          rl.Color,
}

cutscene_scene_init :: proc(shots: []Scene_Shot) -> Cutscene {
	return {result = .Running, shots = shots, current = 0, shot_elapsed = 0}
}

update_cutscene_scene :: proc(scene: ^Cutscene, dt: f32) -> Scene_Result {
	if scene.result == .Complete {
		return .Complete
	}

	if len(scene.shots) == 0 {
		scene.result = .Complete
		return .Complete
	}

	if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.SPACE) {
		advance_cutscene_shot(scene)
		return scene.result
	}

	shot := scene.shots[scene.current]
	scene.shot_elapsed += dt
	if scene.shot_elapsed >= shot.length {
		advance_cutscene_shot(scene)
	}

	return scene.result
}

draw_cutscene_scene :: proc(scene: ^Cutscene) {
	if scene.result == .Complete || len(scene.shots) == 0 {
		return
	}

	shot := scene.shots[scene.current]
	progress := clamp01(scene.shot_elapsed / shot.length)
	camera_position := lerp_vector3(shot.camera_start, shot.camera_end, progress)
	camera_target := lerp_vector3(shot.target_start, shot.target_end, progress)
	shake := screen_shake_offset(shot.shake, scene.shot_elapsed - shot.shake_delay)

	camera := rl.Camera3D {
		position   = add_vector3(camera_position, shake),
		target     = add_vector3(camera_target, shake),
		up         = shot.up,
		fovy       = 45,
		projection = .PERSPECTIVE,
	}

	rl.ClearBackground(shot.background)
	rl.BeginMode3D(camera)
	if shot.show_grid {
		rl.DrawGrid(16, 1)
	}
	draw_cutscene_drawables(shot.drawables, progress)
	rl.EndMode3D()

	if shot.title != "" {
		draw_centered_text(shot.title, 42, -220, rl.RAYWHITE)
	}
	draw_current_cutscene_subtitle(shot.subtitles, scene.shot_elapsed, shot.length)

	if shot.fade_to_black {
		alpha := progress
		rl.DrawRectangle(0, 0, rl.GetScreenWidth(), rl.GetScreenHeight(), rl.ColorAlpha(rl.BLACK, alpha))
	}
}

advance_cutscene_shot :: proc(scene: ^Cutscene) {
	scene.current += 1
	scene.shot_elapsed = 0

	if scene.current >= len(scene.shots) {
		scene.result = .Complete
	}
}

draw_cutscene_drawables :: proc(drawables: []Cutscene_Drawable, progress: f32) {
	for drawable in drawables {
		position := lerp_vector3(drawable.position_start, drawable.position_end, progress)
		size := lerp_vector3(drawable.size_start, drawable.size_end, progress)
		draw_cutscene_asset(drawable.asset, position, size, drawable.color)
	}
}

draw_cutscene_asset :: proc(asset: Cutscene_Asset, position, size: rl.Vector3, color: rl.Color) {
	switch asset {
	case .Primitive_Cube:
		rl.DrawCubeV(position, size, color)
		rl.DrawCubeWiresV(position, size, rl.RAYWHITE)
	case .Fixed_Wing_Drone:
		drones.draw_fixed_wing(position, size, color)
	case .Quadcopter:
		drones.draw_quadcopter(position, size, color)
	case .Pine_Tree:
		trees.draw_pine(position, size, rl.BROWN, color)
	case .Oak_Tree:
		trees.draw_oak(position, size, rl.BROWN, color)
	}
}

draw_current_cutscene_subtitle :: proc(subtitles: []cstring, elapsed, shot_length: f32) {
	if len(subtitles) == 0 || shot_length <= 0 {
		return
	}

	subtitle_index := current_subtitle_index(subtitles, elapsed, shot_length)
	draw_cutscene_subtitle(subtitles[subtitle_index])
}

current_subtitle_index :: proc(subtitles: []cstring, elapsed, shot_length: f32) -> int {
	progress := clamp01(elapsed / shot_length)
	index := int(progress * f32(len(subtitles)))

	if index >= len(subtitles) {
		return len(subtitles) - 1
	}

	return index
}

draw_cutscene_subtitle :: proc(subtitle: cstring) {
	font_size := i32(24)
	text_width := rl.MeasureText(subtitle, font_size)
	x := (rl.GetScreenWidth() - text_width) / 2
	y := rl.GetScreenHeight() - 120
	rl.DrawText(subtitle, x, y, font_size, rl.RAYWHITE)
}

add_vector3 :: proc(a, b: rl.Vector3) -> rl.Vector3 {
	return rl.Vector3{a.x + b.x, a.y + b.y, a.z + b.z}
}
