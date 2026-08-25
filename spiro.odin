package spiro

import rl "vendor:raylib"

WINDOW_TITLE :: "spiro"
STARTING_WINDOW_WIDTH :: 1280
STARTING_WINDOW_HEIGHT :: 720

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT, .WINDOW_RESIZABLE})
	rl.InitWindow(STARTING_WINDOW_WIDTH, STARTING_WINDOW_HEIGHT, WINDOW_TITLE)
	defer rl.CloseWindow()

	enter_fullscreen()
	game := game_init()

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

enter_fullscreen :: proc() {
	monitor := rl.GetCurrentMonitor()
	rl.SetWindowSize(rl.GetMonitorWidth(monitor), rl.GetMonitorHeight(monitor))

	if !rl.IsWindowFullscreen() {
		rl.ToggleFullscreen()
	}
}
