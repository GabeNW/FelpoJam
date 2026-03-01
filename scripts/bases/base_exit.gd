extends Node2D

@export var target_level : PackedScene
@export var spawn_id : String

@onready var area = $Area2D
@onready var wall = $StaticBody2D

func _ready():
	area.body_entered.connect(_on_body_entered)

	# Se não tiver level configurado, vira parede pura
	if target_level == null:
		area.monitoring = false

func _on_body_entered(body):
	if body.name != "Player":
		return
	
	if target_level:
		LevelManager.load_level_scene(target_level, spawn_id)
