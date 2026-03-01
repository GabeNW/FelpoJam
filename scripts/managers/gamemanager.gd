extends Node

enum GameState {
	MENU,
	PLAYING,
	FINAL
}

var state: GameState = GameState.MENU
var current_level_path : String = ""

# Fluxo principal do jogo
func go_to_menu():
	state = GameState.MENU
	get_tree().change_scene_to_file("res://ui/menu.tscn")

func start_game():
	state = GameState.PLAYING
	# Começa no level 1 por enquanto
	current_level_path = "res://scenes/gameScenes/Level1.tscn"
	LevelManager.load_level_by_path(current_level_path, "spawn_down")

func go_to_final():
	state = GameState.FINAL
	get_tree().change_scene_to_file("res://ui/final_scene.tscn")
