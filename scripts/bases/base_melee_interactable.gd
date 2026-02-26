extends StaticBody2D
class_name BaseMeleeInteractable

@export var charge_cost: int = 0
var current_charge: int = 0
var charges: Dictionary = {}

func _ready():
	add_to_group("melee_interactable")

func on_melee_hit(player):
	if charge_cost > 0:
		if not player.consume_charge(charge_cost):
			return
	
	activate(player)

func activate(player):
	pass
