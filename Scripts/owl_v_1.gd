extends CharacterBody3D


@export_category("Movimiento")
@export var _walking_speed : float = 1
@export var _acceleration : float = 2
@export var _deceleration : float  = 4
@export var _rotation_speed : float = PI * 3
var _angle_difference : float
var _direction : Vector3
var _xz_velocity : Vector3

@onready var _animation : AnimationTree = $AnimationTree
@onready var _state_machine : AnimationNodeStateMachinePlayback = _animation["parameters/playback"]
@onready var _rig : Node3D = $rig

@export_category("Salto")
@export var _jump_height : float = 3
@export var _mass : float = 1
var _jump_velocity : float
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	_jump_velocity = sqrt(_jump_height * _gravity * _mass * 2)

func move(direction : Vector3):
	_direction = direction
	
func jump():
	if is_on_floor():
		_state_machine.travel("jumpstart")
		
func _apply_jump_velocity():
		velocity.y = _jump_velocity

func _physics_process(delta: float) -> void:
	

	if _direction:
		_angle_difference = wrapf(atan2(_direction.x, _direction.z) - _rig.rotation.y, -PI, PI)
		_rig.rotation.y += clamp(_rotation_speed * delta, 0, abs(_angle_difference)) * sign(_angle_difference)
	
	_xz_velocity = Vector3(velocity.x, 0, velocity.z)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= _gravity * _mass * delta


	if _direction:
		if _direction.dot(velocity) >= 0:
			_xz_velocity = _xz_velocity.move_toward (_direction * _walking_speed, _acceleration * delta)
		else:
			_xz_velocity = _xz_velocity.move_toward (_direction * _walking_speed, _deceleration * delta)
	else:
		_xz_velocity = _xz_velocity.move_toward (Vector3.ZERO * _walking_speed, _deceleration * delta)
		
	_animation.set("parameters/Locomotion/blend_position", _xz_velocity.length() / _walking_speed)

	velocity.x = _xz_velocity.x
	velocity.z = _xz_velocity.z

	move_and_slide()
