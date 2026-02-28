# Dependencias
extends CharacterBody2D

# Movimento
@export var speed: float = 200
var last_direction: Vector2 = Vector2.DOWN

# Ataque
@export var attack_range: float = 40.0
@export var attack_cooldown: float = 0.3

@export var attack_offset_x := 15.0
@export var attack_offset_up := 15.0
@export var attack_offset_down := 25.0

# Animacao
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $AttackHitbox
@onready var hitbox_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D

@export var attack_active_start := 8
@export var attack_active_end := 11

var is_attacking := false
var already_hit := []

# Cargas
@export var max_charges := {
	"energy": 5
}

var charges := {}

# Funcoes Gerais
## Ataque
func attack():
	if is_attacking:
		return
	
	is_attacking = true
	update_hitbox_direction()
	play_attack_animation()
	already_hit.clear()

func update_hitbox_direction():
	var rect := hitbox_shape.shape as RectangleShape2D
	
	if abs(last_direction.x) > 0:
		rect.size = Vector2(20, 40)
	else:
		rect.size = Vector2(40, 20)

	var offset := Vector2.ZERO
	
	match last_direction:
		Vector2.RIGHT:
			offset = Vector2(attack_offset_x, 0)
		Vector2.LEFT:
			offset = Vector2(-attack_offset_x, 0)
		Vector2.UP:
			offset = Vector2(0, -attack_offset_up)
		Vector2.DOWN:
			offset = Vector2(0, attack_offset_down)

	hitbox.position = offset

func _on_attack_body_entered(body):
	if body in already_hit:
		return
	already_hit.append(body)
	
	if body.has_method("on_melee_hit"):
		body.on_melee_hit(self)

## Animacao
### Estados
func play_attack_animation():
	var anim := ""
	match last_direction:
		Vector2.RIGHT, Vector2.LEFT:
			anim = "attack_right"
		Vector2.UP:
			anim = "attack_up"
		Vector2.DOWN:
			anim = "attack_down"
	if sprite.animation != anim:
		sprite.play(anim)

func play_idle_animation():
	var anim := ""
	match last_direction:
		Vector2.RIGHT, Vector2.LEFT:
			anim = "idle_right"
		Vector2.UP:
			anim = "idle_up"
		Vector2.DOWN:
			anim = "idle_down"
	if sprite.animation != anim:
		sprite.play(anim)

func play_run_animation():
	var anim := ""
	match last_direction:
		Vector2.RIGHT, Vector2.LEFT:
			anim = "run_right"
		Vector2.UP:
			anim = "run_up"
		Vector2.DOWN:
			anim = "run_down"
	if sprite.animation != anim:
		sprite.play(anim)

### Gerais
func _on_frame_changed():
	if not sprite.animation.begins_with("attack"):
		return
	
	hitbox_shape.disabled = not (
		sprite.frame >= attack_active_start and 
		sprite.frame <= attack_active_end
	)

func _on_animation_finished():
	if sprite.animation.begins_with("attack"):
		hitbox_shape.disabled = true
		is_attacking = false
	
	# Forca atualizar o frame para outra animacao
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	update_movement_animation(direction)

func update_movement_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		play_idle_animation()
	else:
		play_run_animation()

## Carga
func add_charge(type: String, amount: int):
	if not charges.has(type):
		charges[type] = 0
	
	charges[type] = clamp(
		charges[type] + amount,
		0,
		max_charges.get(type, amount)
	)
	
	print("Carga ", type, ":", charges[type])	

func consume_charge(type: String, amount: int) -> bool:
	if not charges.has(type):
		return false
	
	if charges[type] >= amount:
		charges[type] -= amount
		print("Consumiu: ", amount, " de ", type)
		return true
	
	print("Carga insuficiente: ", type)
	return false

# Funcoes Essenciais
## Start
func _ready():
	# Inicializa as cargas com 0
	for type in max_charges.keys():
		charges[type] = 0
	
	hitbox.body_entered.connect(_on_attack_body_entered)
	sprite.frame_changed.connect(_on_frame_changed)
	sprite.animation_finished.connect(_on_animation_finished)
	
	# Inicializa com sprite default
	sprite.play("idle_down")
	last_direction = Vector2.DOWN

## Update
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()

## FixedUpdate
func _physics_process(delta):
	# Input do Movimento
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Impede de se movimentar enquanto ataca
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Movimento
	velocity = direction * speed
	move_and_slide()
	
	# Direcao do ultimo movimento
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2(sign(direction.x), 0)
		else:
			last_direction = Vector2(0, sign(direction.y))
	
	# Flip horizontal da animacao
	if last_direction == Vector2.LEFT:
		sprite.flip_h = true
	elif last_direction == Vector2.RIGHT:
		sprite.flip_h = false
	
	update_movement_animation(direction)
