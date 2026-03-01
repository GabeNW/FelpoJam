extends Node2D

@export var target_level_path : String = ""
@export var spawn_id : String = ""

@onready var area: Area2D = $Area2D

var transitioning := false

func _ready():
	area.body_entered.connect(_on_body_entered)
	if target_level_path == "":
		area.monitoring = false

func _on_body_entered(body):
	if transitioning:
		return
	if not body.is_in_group("player"):
		return
	if target_level_path == "":
		return

	transitioning = true
	LevelManager.call_deferred(
		"load_level_by_path",
		target_level_path,
		spawn_id
	)
