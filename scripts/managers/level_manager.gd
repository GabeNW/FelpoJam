extends Node

var current_level : Node = null
var level_container : Node2D = null
var player : CharacterBody2D = null

func register_container(container):
	level_container = container
func register_player(p):
	player = p

# Funcoes principais
func load_level_by_path(path: String, spawn_id: String = ""):
	var scene = load(path)
	load_level_scene(scene, spawn_id)

func load_level_scene(scene: PackedScene, spawn_id: String = ""):
	if current_level:
		current_level.queue_free()

	current_level = scene.instantiate()
	level_container.add_child(current_level)

	await get_tree().process_frame
	position_player(spawn_id)
	position_camera()

	if Engine.has_singleton("GameManager"):
		GameManager.current_level_path = current_level.scene_file_path

# Posiciona o player no lugar correto
func position_player(spawn_id: String):
	if spawn_id == "":
		return

	var spawn_node = current_level.get_node_or_null("SpawnPoints/" + spawn_id)
	if spawn_node and player:
		player.global_position = spawn_node.global_position

# Posiciona a camera no mesmo lugar
func position_camera():
	var anchor = current_level.get_node_or_null("CameraAnchor")
	if anchor:
		var cam = get_tree().current_scene.get_node("Camera2D")
		cam.global_position = anchor.global_position
