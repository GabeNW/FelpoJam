extends BaseMeleeInteractable

@export var charge_amount: int = 2

func activate(player):
	player.add_charge(charge_amount)
	print("Recarga concedida!")
