package spiro

import "core:os"
import rl "vendor:raylib"

WINDOW_TITLE :: "spiro"
STARTING_WINDOW_WIDTH :: 1280
STARTING_WINDOW_HEIGHT :: 720

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE})
	rl.InitWindow(STARTING_WINDOW_WIDTH, STARTING_WINDOW_HEIGHT, WINDOW_TITLE)
	defer rl.CloseWindow()

	enter_fullscreen()
	game := game_init(parse_launch_config())

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		update_game(&game, dt)

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		draw_game(&game)
		rl.EndDrawing()
	}
}

parse_launch_config :: proc() -> Game_Config {
	config := game_default_config()

	for arg in os.args {
		switch arg {
		case "-field":
			config.start_ui = .Field
			config.field_kind = .Forest
		case "-plains":
			config.start_ui = .Field
			config.field_kind = .Plains
		case "-mountains":
			config.start_ui = .Field
			config.field_kind = .Mountains
		case "-desert":
			config.start_ui = .Field
			config.field_kind = .Desert
		case "-debug":
			config.debug = true
		}
	}

	return config
}

enter_fullscreen :: proc() {
	monitor := rl.GetCurrentMonitor()
	rl.SetWindowSize(rl.GetMonitorWidth(monitor), rl.GetMonitorHeight(monitor))

	if !rl.IsWindowFullscreen() {
		rl.ToggleFullscreen()
	}
}
