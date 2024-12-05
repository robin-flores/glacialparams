extends Node

@export var _character1 : CharacterBody3D
@export var _camera : Camera3D

@export_category("ID")
@export var player_id = 1

var _input_direction : Vector2
var _move_direction : Vector3


func _input(event : InputEvent):
	if event.is_action_pressed("jump_%s" % [player_id]):
		_character1.jump()

func _process (_delta : float):
	_input_direction = Input.get_vector(
	"move_left_%s" % [player_id], 
	"move_right_%s" % [player_id], 
	"move_forward_%s" % [player_id], 
	"move_backward_%s" % [player_id])
	_move_direction = (_camera.basis.x * Vector3(1, 0, 1)).normalized() * _input_direction.x
	_move_direction += (_camera.basis.z * Vector3(1, 0, 1)).normalized() * _input_direction.y
	_character1.move(_move_direction)
