# Dependencias
extends CharacterBody2D

# Movimento
@export var speed: float = 200

# Interacao
@export var interaction_time: float = 0.2
@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $Area2D
var original_color: Color

func perform_interaction():
	# Feedback visual no player
	flash_red()
	var bodies = interaction_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("interactable"):
			body.interact()
			
func flash_red():
	sprite.modulate = Color.RED
	await get_tree().create_timer(interaction_time).timeout
	sprite.modulate = original_color


# Funcoes Gerais
func _ready():
	original_color = sprite.modulate
	
func _process(delta):
	# Interacao
	if Input.is_action_just_pressed("interact"):
		perform_interaction()

func _physics_process(delta: float) -> void:
	# Movimento
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
