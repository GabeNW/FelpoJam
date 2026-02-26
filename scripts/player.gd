# Dependencias
extends CharacterBody2D

# Movimento
@export var speed: float = 200
var last_direction: Vector2 = Vector2.DOWN

# Ataque
@export var attack_range: float = 40.0
@export var attack_cooldown: float = 0.3

@onready var attack_ray: RayCast2D = $AttackRay

var can_attack: bool = true

# Cargas
@export var max_charges := {
	"energy": 5
}

var charges := {}

# Funcoes Gerais
## Ataque
func attack():
	if not can_attack:
		return
	
	can_attack = false
	
	# Direciona ray
	attack_ray.target_position = last_direction * attack_range
	attack_ray.force_raycast_update()
	
	show_slash()
	
	if attack_ray.is_colliding():
		var body = attack_ray.get_collider()
		
		if body.has_method("on_melee_hit"):
			body.on_melee_hit(self)
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func show_slash():
	var offset = last_direction * (attack_range * 0.5)
	
## Carga
func add_charge(type: String, amount: int):
	if not charges.has(type):
		charges[type] = 0
	
	charges[type] = clamp(
		charges[type] + amount,
		0,
		max_charges.get(type, amount)
	)
	
	print("Carga", type, ":", charges[type])	

func consume_charge(type: String, amount: int) -> bool:
	if not charges.has(type):
		return false
	
	if charges[type] >= amount:
		charges[type] -= amount
		print("Consumiu: ", amount, type)
		return true
	
	print("Carga insuficiente: ", type)
	return false

# Funcoes Essenciais
## Start
func _ready():
	attack_ray.enabled = true
	# Inicializa todas as cargas com 0
	for type in max_charges.keys():
		charges[type] = 0

## Update
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()

## FixedUpdate
func _physics_process(delta):
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
