extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _direction : Vector3

func move(direction : Vector3):
	_direction = direction

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_1") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	if _direction:
		velocity.x = _direction.x * SPEED
		velocity.z = _direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
