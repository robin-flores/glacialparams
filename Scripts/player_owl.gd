extends Node

@export var _character2: CharacterBody3D
@export var _camera: Camera3D
var _input_direction: Vector2
var _move_direction: Vector3

func _input(event: InputEvent):
	if event.is_action_pressed("jump_2"):
		_character2.jump()

func _process(_delta: float):
	# Detectar la dirección de entrada del jugador.
	_input_direction = Input.get_vector("move_left_2", "move_right_2", "move_forward_2", "move_backward_2")

	# Notificar al nodo Magnet si el jugador está moviendo a owl_v2.
	var input_detectado = _input_direction != Vector2.ZERO  # Detecta si hay input en cualquier dirección.
	get_node("../Magnet").set_jugador_moviendo(input_detectado)

	# Calcular la dirección de movimiento en el espacio 3D.
	_move_direction = (_camera.basis.x * Vector3(1, 0, 1)).normalized() * _input_direction.x
	_move_direction += (_camera.basis.z * Vector3(1, 0, 1)).normalized() * _input_direction.y

	# Mover a owl_v2 según la dirección de entrada.
	_character2.move(_move_direction)
