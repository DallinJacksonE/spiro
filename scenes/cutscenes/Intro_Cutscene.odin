package cutscenes

import rl "vendor:raylib"
import scenes ".."

NO_SUBTITLES := [?]cstring {}

SHOT_2_SUBTITLES := [?]cstring {
	"The Age of Clans came after the Swarm Wars, but in truth, the Wars haven't stopped.",
	"Now every Clan seeks to establish itself in the vacuum left by the old Powers.",
	"My family built weapons for the Old World, and we went into hiding as it crumbled.",
}

SHOT_3_SUBTITLES := [?]cstring {
	"We were betrayed, and because we refused to make weapons again, attacked with the very weapons we built for the generation before.",
}

SHOT_4_SUBTITLES := [?]cstring {
	"'Run, you must run and learn to control the Swarms'",
	"The last thing I heard from my father",
}

SHOT_1_DRAWABLES := [?]scenes.Cutscene_Drawable {
	{
		position_start = rl.Vector3{0, 2, -8},
		position_end = rl.Vector3{0, 2, -8},
		size_start = rl.Vector3{0.5, 0.5, 0.5},
		size_end = rl.Vector3{7, 7, 7},
		color = rl.ORANGE,
	},
	{
		position_start = rl.Vector3{0, 1.2, -6},
		position_end = rl.Vector3{0, 1.2, -1},
		size_start = rl.Vector3{0.2, 0.05, 0.2},
		size_end = rl.Vector3{12, 0.05, 12},
		color = rl.YELLOW,
	},
}

SHOT_2_DRAWABLES := [?]scenes.Cutscene_Drawable {
	{
		asset = .Pine_Tree,
		position_start = rl.Vector3{-4, 2, 8},
		position_end = rl.Vector3{-4, 2, -18},
		size_start = rl.Vector3{1.6, 4, 1.6},
		size_end = rl.Vector3{1.6, 4, 1.6},
		color = rl.DARKGREEN,
	},
	{
		asset = .Oak_Tree,
		position_start = rl.Vector3{3, 2, 5},
		position_end = rl.Vector3{3, 2, -21},
		size_start = rl.Vector3{1.8, 3.6, 1.8},
		size_end = rl.Vector3{1.8, 3.6, 1.8},
		color = rl.GREEN,
	},
	{
		asset = .Pine_Tree,
		position_start = rl.Vector3{-2, 2, 0},
		position_end = rl.Vector3{-2, 2, -26},
		size_start = rl.Vector3{1.4, 4.2, 1.4},
		size_end = rl.Vector3{1.4, 4.2, 1.4},
		color = rl.DARKGREEN,
	},
	{
		asset = .Oak_Tree,
		position_start = rl.Vector3{5, 2, -3},
		position_end = rl.Vector3{5, 2, -29},
		size_start = rl.Vector3{1.5, 3.8, 1.5},
		size_end = rl.Vector3{1.5, 3.8, 1.5},
		color = rl.GREEN,
	},
}

SHOT_3_DRAWABLES := [?]scenes.Cutscene_Drawable {
	{
		asset = .Fixed_Wing_Drone,
		position_start = rl.Vector3{-3, 5, -8},
		position_end = rl.Vector3{1, 2, -3},
		size_start = rl.Vector3{3.6, 0.7, 2.4},
		size_end = rl.Vector3{3.6, 0.7, 2.4},
		color = rl.LIGHTGRAY,
	},
	{
		position_start = rl.Vector3{-3, 4.5, -7.5},
		position_end = rl.Vector3{1.2, 0.2, -2.6},
		size_start = rl.Vector3{0.45, 0.45, 0.45},
		size_end = rl.Vector3{0.35, 0.35, 0.35},
		color = rl.MAROON,
	},
}

SHOT_4_DRAWABLES := [?]scenes.Cutscene_Drawable {
	{
		position_start = rl.Vector3{0, 0.1, 0},
		position_end = rl.Vector3{0, 0.1, 0},
		size_start = rl.Vector3{14, 0.1, 14},
		size_end = rl.Vector3{14, 0.1, 14},
		color = rl.DARKBLUE,
	},
	{
		position_start = rl.Vector3{-2, 0.4, 5},
		position_end = rl.Vector3{2, 0.4, -5},
		size_start = rl.Vector3{0.5, 0.8, 0.5},
		size_end = rl.Vector3{0.5, 0.8, 0.5},
		color = rl.RED,
	},
	{
		asset = .Pine_Tree,
		position_start = rl.Vector3{-4, 0.6, -1},
		position_end = rl.Vector3{-4, 0.6, -1},
		size_start = rl.Vector3{1.2, 1.8, 1.2},
		size_end = rl.Vector3{1.2, 1.8, 1.2},
		color = rl.BLUE,
	},
	{
		asset = .Pine_Tree,
		position_start = rl.Vector3{4, 0.6, 2},
		position_end = rl.Vector3{4, 0.6, 2},
		size_start = rl.Vector3{1.2, 1.8, 1.2},
		size_end = rl.Vector3{1.2, 1.8, 1.2},
		color = rl.BLUE,
	},
}

SHOT_5_DRAWABLES := [?]scenes.Cutscene_Drawable {
	{
		position_start = rl.Vector3{0, 2, 6},
		position_end = rl.Vector3{0, 5, -1},
		size_start = rl.Vector3{0.45, 1.2, 0.45},
		size_end = rl.Vector3{0.45, 1.2, 0.45},
		color = rl.RAYWHITE,
	},
	{
		position_start = rl.Vector3{0, 1.5, 10},
		position_end = rl.Vector3{0, 1.5, 10},
		size_start = rl.Vector3{0.8, 0.8, 0.8},
		size_end = rl.Vector3{7, 7, 7},
		color = rl.ORANGE,
	},
	{
		asset = .Pine_Tree,
		position_start = rl.Vector3{0, 2.5, -4},
		position_end = rl.Vector3{0, 2.5, -4},
		size_start = rl.Vector3{2.0, 5, 2.0},
		size_end = rl.Vector3{2.0, 5, 2.0},
		color = rl.DARKGREEN,
	},
}

SHOT_6_DRAWABLES := [?]scenes.Cutscene_Drawable {
	{
		position_start = rl.Vector3{0, 1, -8},
		position_end = rl.Vector3{0, 1, -8},
		size_start = rl.Vector3{12, 2, 1.5},
		size_end = rl.Vector3{12, 2, 1.5},
		color = rl.DARKGRAY,
	},
	{
		position_start = rl.Vector3{-2, 2.5, -8},
		position_end = rl.Vector3{-2, 4, -8},
		size_start = rl.Vector3{1.2, 1.2, 1.2},
		size_end = rl.Vector3{1.8, 3, 1.8},
		color = rl.ORANGE,
	},
	{
		position_start = rl.Vector3{2.5, 2.5, -8},
		position_end = rl.Vector3{2.5, 3.5, -8},
		size_start = rl.Vector3{1, 1, 1},
		size_end = rl.Vector3{1.5, 2.5, 1.5},
		color = rl.RED,
	},
}

INTRO_CUTSCENE_SHOTS := [?]scenes.Scene_Shot {
	{
		length = 2.4,
		camera_start = rl.Vector3{0, 2, 2},
		camera_end = rl.Vector3{0, 2, 1.2},
		target_start = rl.Vector3{0, 1.8, -8},
		target_end = rl.Vector3{0, 1.8, -3},
		up = rl.Vector3{0, 1, 0},
		background = rl.BLACK,
		show_grid = false,
		shake_delay = 1.1,
		shake = scenes.Screen_Shake{duration = 1.1, strength = 0.55, frequency = 32},
		title = "",
		subtitles = NO_SUBTITLES[:],
		drawables = SHOT_1_DRAWABLES[:],
	},
	{
		length = 8.0,
		camera_start = rl.Vector3{0, 1.7, 12},
		camera_end = rl.Vector3{0, 1.7, -12},
		target_start = rl.Vector3{0, 1.5, 4},
		target_end = rl.Vector3{0, 1.5, -20},
		up = rl.Vector3{0, 1, 0},
		background = rl.DARKGREEN,
		show_grid = false,
		shake_delay = 0,
		shake = scenes.Screen_Shake{duration = 8.0, strength = 0.08, frequency = 18},
		title = "",
		subtitles = SHOT_2_SUBTITLES[:],
		drawables = SHOT_2_DRAWABLES[:],
	},
	{
		length = 5.5,
		camera_start = rl.Vector3{0, 3, 5},
		camera_end = rl.Vector3{0, 2.5, 4},
		target_start = rl.Vector3{-3, 5, -8},
		target_end = rl.Vector3{1, 1.5, -3},
		up = rl.Vector3{0, 1, 0},
		background = rl.BLACK,
		show_grid = false,
		shake_delay = 0,
		shake = scenes.Screen_Shake{},
		title = "",
		subtitles = SHOT_3_SUBTITLES[:],
		drawables = SHOT_3_DRAWABLES[:],
	},
	{
		length = 5.0,
		camera_start = rl.Vector3{0, 18, 0},
		camera_end = rl.Vector3{0, 18, -4},
		target_start = rl.Vector3{0, 0, 0},
		target_end = rl.Vector3{0, 0, -4},
		up = rl.Vector3{0, 0, -1},
		background = rl.BLACK,
		show_grid = false,
		shake_delay = 0,
		shake = scenes.Screen_Shake{},
		title = "THERMAL",
		subtitles = SHOT_4_SUBTITLES[:],
		drawables = SHOT_4_DRAWABLES[:],
	},
	{
		length = 3.5,
		camera_start = rl.Vector3{0, 1.7, 3},
		camera_end = rl.Vector3{0, 4, -1},
		target_start = rl.Vector3{0, 1.5, 8},
		target_end = rl.Vector3{0, 2.5, -4},
		up = rl.Vector3{0, 1, 0},
		background = rl.DARKGREEN,
		show_grid = false,
		shake_delay = 0.5,
		shake = scenes.Screen_Shake{duration = 2.4, strength = 0.45, frequency = 28},
		title = "",
		subtitles = NO_SUBTITLES[:],
		drawables = SHOT_5_DRAWABLES[:],
	},
	{
		length = 5.0,
		camera_start = rl.Vector3{0, 1.2, 2},
		camera_end = rl.Vector3{0, 1.0, 2.2},
		target_start = rl.Vector3{0, 2.2, -8},
		target_end = rl.Vector3{0, 2.8, -8},
		up = rl.Vector3{0, -1, 0},
		background = rl.BLACK,
		show_grid = false,
		fade_to_black = true,
		shake_delay = 0,
		shake = scenes.Screen_Shake{},
		title = "",
		subtitles = NO_SUBTITLES[:],
		drawables = SHOT_6_DRAWABLES[:],
	},
}

intro_cutscene_scene_init :: proc() -> scenes.Cutscene {
	return scenes.cutscene_scene_init(INTRO_CUTSCENE_SHOTS[:])
}
