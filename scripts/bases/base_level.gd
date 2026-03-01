extends Node2D
class_name BaseLevel

@export var level_id : String
@export var reset_on_exit := false
@export var has_objective := false

var objective_completed := false

# Fluxo de objetivos por level
func complete_level():
	objective_completed = true

func check_objective():
	return objective_completed

func reset_level():
	pass
