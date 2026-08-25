// Dallin Jackson 24/8/26

package spiro

import cutscenes "scenes/cutscenes"
import scenes "scenes"
import states "states"

Cutscene_Map :: [states.Story]scenes.Cutscene

Game :: struct {
	display:          states.Display,
	ui:               states.UI,
	studio_intro:     scenes.Studio_Intro_Scene,
	main_menu:        scenes.Main_Menu_Scene,
	cutscenes:        Cutscene_Map,
	current_cutscene: states.Story,
}

game_init :: proc() -> Game {
	return {
		display = .WindowOpen,
		ui = .StudioIntro,
		studio_intro = scenes.studio_intro_scene_init(),
		main_menu = scenes.main_menu_scene_init(),
		cutscenes = cutscene_map_init(),
		current_cutscene = .Intro,
	}
}

cutscene_map_init :: proc() -> Cutscene_Map {
	cutscene_map: Cutscene_Map
	cutscene_map[.Intro] = cutscenes.intro_cutscene_scene_init()
	return cutscene_map
}

update_game :: proc(game: ^Game, dt: f32) {
	switch game.ui {
	case .StudioIntro:
		if scenes.update_studio_intro_scene(&game.studio_intro, dt) == .Complete {
			transition_to_ui(game, .MainMenu)
		}
	case .MainMenu:
		if scenes.update_main_menu_scene(&game.main_menu, dt) == .Complete {
			transition_to_ui(game, .Cutscene)
		}
	case .Cutscene:
		if scenes.update_cutscene_scene(&game.cutscenes[game.current_cutscene], dt) == .Complete {
			transition_to_ui(game, .Field)
		}
	case .Workshop, .Field, .Dialog, .Settings, .PauseMenu:
	// Other UI states will be added as their scenes become real.
	}
}

draw_game :: proc(game: ^Game) {
	switch game.ui {
	case .StudioIntro:
		scenes.draw_studio_intro_scene(&game.studio_intro)
	case .MainMenu:
		scenes.draw_main_menu_scene(&game.main_menu)
	case .Cutscene:
		scenes.draw_cutscene_scene(&game.cutscenes[game.current_cutscene])
	case .Workshop, .Field, .Dialog, .Settings, .PauseMenu:
		scenes.draw_placeholder_scene("Scene not implemented yet")
	}
}

transition_to_ui :: proc(game: ^Game, next: states.UI) {
	game.ui = next

	switch next {
	case .MainMenu:
		game.main_menu = scenes.main_menu_scene_init()
	case .Cutscene:
		game.current_cutscene = .Intro
		game.cutscenes[game.current_cutscene] = cutscenes.intro_cutscene_scene_init()
	case .StudioIntro, .Workshop, .Field, .Dialog, .Settings, .PauseMenu:
	}
}
