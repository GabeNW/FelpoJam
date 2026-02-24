extends StaticBody2D
class_name BaseInteractable

@export var interaction_enabled: bool = true

func _ready():
	add_to_group("interactable")
	# Interagir
	if sprite:
		original_color = sprite.modulate

func interact():
	if not interaction_enabled:
		return
	
	flash()
	print("Objeto interagido!")


@export var flash_time: float = 0.2
@onready var sprite: Sprite2D = $Sprite2D
var original_color: Color

func flash() -> void:
	if not sprite:
		return
		
	sprite.modulate = Color.RED
	await get_tree().create_timer(flash_time).timeout
	sprite.modulate = original_color
