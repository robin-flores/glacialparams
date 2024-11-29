extends Node

@export var _character1 : CharacterBody3D
@export var _camera : Camera3D
var _input_direction : Vector2
var _move_direction : Vector3

func _input(event : InputEvent):
	if event.is_action_pressed("jump_1"):
		_character1.jump()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	_input_direction = Input.get_vector("move_left_1", "move_right_1", "move_forward_1", "move_backward_1")
	_move_direction = (_camera.basis.x * Vector3(1, 0, 1)).normalized() * _input_direction.x
	_move_direction += (_camera.basis.z * Vector3(1, 0, 1)).normalized() * _input_direction.y
	_character1.move(_move_direction)
