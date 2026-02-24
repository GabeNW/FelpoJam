extends BaseInteractable 

func interact(): 
	if not interaction_enabled:
		return
		
	await flash()
	queue_free()
	print("Caixa destruída!") 
