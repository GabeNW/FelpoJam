extends Node2D

@onready var level_container = $LevelContainer
@onready var player = $Player

func _ready():
	LevelManager.register_container(level_container)
	LevelManager.register_player(player)
	
	GameManager.start_game()
