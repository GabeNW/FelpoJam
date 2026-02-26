extends StaticBody2D
class_name BaseMeleeObject

@export var charge_type: String = "energy"
@export var charge_cost: int = 0

func on_melee_hit(player):
	if charge_cost > 0:
		if not player.consume_charge(charge_type, charge_cost):
			return
	
	activate(player)

func activate(player):
	pass
