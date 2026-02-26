extends BaseMeleeObject

@export var recharge_amount: int = 2

func activate(player):
	player.add_charge(charge_type, recharge_amount)
	print("Recarga concedida!")
