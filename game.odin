// Dallin Jackson 24/8/26

package spiro

import cutscenes "scenes/cutscenes"
import scenes "scenes"
import states "states"

Cutscene_Map :: [states.Story]scenes.Cutscene

Game_Config :: struct {
	start_ui:   states.UI,
	field_kind: scenes.Field_Map_Kind,
	debug:      bool,
}

Game :: struct {
	display:          states.Display,
	ui:               states.UI,
	studio_intro:     scenes.Studio_Intro_Scene,
	main_menu:        scenes.Main_Menu_Scene,
	field:            scenes.Field_Scene,
	cutscenes:        Cutscene_Map,
	current_cutscene: states.Story,
	config:           Game_Config,
}

game_default_config :: proc() -> Game_Config {
	return {start_ui = .StudioIntro, field_kind = .Forest, debug = false}
}

game_init :: proc(config: Game_Config) -> Game {
	return {
		display = .WindowOpen,
		ui = config.start_ui,
		studio_intro = scenes.studio_intro_scene_init(),
		main_menu = scenes.main_menu_scene_init(),
		field = scenes.field_scene_with_debug_init(config.field_kind, config.debug),
		cutscenes = cutscene_map_init(),
		current_cutscene = .Intro,
		config = config,
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
	case .Field:
		scenes.update_field_scene(&game.field, dt)
	case .Workshop, .Dialog, .Settings, .PauseMenu:
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
	case .Field:
		scenes.draw_field_scene(&game.field)
	case .Workshop, .Dialog, .Settings, .PauseMenu:
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
	case .Field:
		game.field = scenes.field_scene_with_debug_init(game.config.field_kind, game.config.debug)
	case .StudioIntro, .Workshop, .Dialog, .Settings, .PauseMenu:
	}
}
