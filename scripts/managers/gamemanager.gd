extends Node

enum GameState {
	MENU,
	PLAYING,
	FINAL
}

var state: GameState = GameState.MENU
var current_level_index: int = 0

var levels := [
	"res://levels/level_1.tscn",
]

var level_container: Node = null
