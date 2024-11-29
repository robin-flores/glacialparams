extends Node

@export var _character2 : CharacterBody3D
@export var _camera : Camera3D
var _input_direction : Vector2
var _move_direction : Vector3

func _input(event : InputEvent):
	if event.is_action_pressed("jump_2"):
		_character2.jump()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	_input_direction = Input.get_vector("move_left_2", "move_right_2", "move_forward_2", "move_backward_2")
	_move_direction = (_camera.basis.x * Vector3(1, 0, 1)).normalized() * _input_direction.x
	_move_direction += (_camera.basis.z * Vector3(1, 0, 1)).normalized() * _input_direction.y
	_character2.move(_move_direction)
