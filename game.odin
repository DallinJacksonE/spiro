// Dallin Jackson 24/8/26

package spiro

import scenes "scenes"
import states "states"
Game :: struct {
	display:      states.Display,
	ui:           states.UI,
	studio_intro: scenes.Studio_Intro_Scene,
	main_menu:    scenes.Main_Menu_Scene,
}

game_init :: proc() -> Game {
	return {
		display = .WindowOpen,
		ui = .StudioIntro,
		studio_intro = scenes.studio_intro_scene_init(),
		main_menu = scenes.main_menu_scene_init(),
	}
}

update_game :: proc(game: ^Game, dt: f32) {
	switch game.ui {
	case .StudioIntro:
		if scenes.update_studio_intro_scene(&game.studio_intro, dt) == .Complete {
			transition_to_ui(game, .MainMenu)
		}
	case .MainMenu:
		if scenes.update_main_menu_scene(&game.main_menu, dt) == .Complete {
			transition_to_ui(game, .Field)
		}
	case .Workshop, .Field, .Cutscene, .Dialog, .Settings, .PauseMenu:
	// Other UI states will be added as their scenes become real.
	}
}

draw_game :: proc(game: ^Game) {
	switch game.ui {
	case .StudioIntro:
		scenes.draw_studio_intro_scene(&game.studio_intro)
	case .MainMenu:
		scenes.draw_main_menu_scene(&game.main_menu)
	case .Workshop, .Field, .Cutscene, .Dialog, .Settings, .PauseMenu:
		scenes.draw_placeholder_scene("Scene not implemented yet")
	}
}

transition_to_ui :: proc(game: ^Game, next: states.UI) {
	game.ui = next

	switch next {
	case .MainMenu:
		game.main_menu = scenes.main_menu_scene_init()
	case .StudioIntro, .Workshop, .Field, .Cutscene, .Dialog, .Settings, .PauseMenu:
	}
}
