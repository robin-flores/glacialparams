extends Node

@export var rango_maximo: float = 10.0  # Rango máximo en metros.
@export var rango_minimo: float = 2.0   # Rango mínimo en metros.
@export var velocidad_seguimiento: float = 3.0  # Velocidad a la que owl_v2 seguirá a crow_v2.

@onready var crow_v2 = get_node("../crow_v2")  # Ruta relativa para crow_v2.
@onready var owl_v2 = get_node("../owl_v2")  # Ruta relativa para owl_v2.
@onready var sonido_rango_max = crow_v2.get_node("Worried_AudioStreamPlayer3D")  # Sonido para rango máximo.
@onready var sonido_rango_min = crow_v2.get_node("Angry_AudioStreamPlayer3D")  # Sonido para rango mínimo.
@onready var owl_animation_tree = owl_v2.get_node("AnimationTree")  # AnimationTree de owl_v2.

var owl_pos_anterior: Vector3  # Guarda la posición anterior de owl_v2 para calcular el movimiento.
var jugador_moviendo: bool = false  # Indica si el jugador está controlando a owl_v2.

# Función que verifica la distancia y maneja los sonidos.
func _process(_delta):
	var distancia = crow_v2.global_position.distance_to(owl_v2.global_position)

	if distancia > rango_maximo and not jugador_moviendo:
		manejar_sonido(sonido_rango_max, sonido_rango_min)  # Activar sonido máximo.
		mover_owl_v2_hacia(crow_v2.global_position)
	elif distancia < rango_minimo and not jugador_moviendo:
		manejar_sonido(sonido_rango_min, sonido_rango_max)  # Activar sonido mínimo.
		mover_owl_v2_a_rango(rango_minimo)
	else:
		detener_sonidos()  # Detener ambos sonidos si está dentro del rango permitido.

	# Actualizar animación según el movimiento.
	actualizar_animacion()

# Función para mover a owl_v2 hacia una posición.
func mover_owl_v2_hacia(destino: Vector3):
	# Movimiento hacia el destino.
	var direccion = (destino - owl_v2.global_position).normalized()
	owl_pos_anterior = owl_v2.global_position  # Guarda la posición actual antes de mover.

	# Mirar hacia crow_v2 antes de moverse.
	owl_v2.look_at(destino)

	# Mover hacia el destino.
	owl_v2.global_position += direccion * velocidad_seguimiento * get_process_delta_time()

# Función que ajusta a owl_v2 dentro de los rangos.
func mover_owl_v2_a_rango(rango_objetivo):
	var direccion = (crow_v2.global_position - owl_v2.global_position).normalized()
	var nuevo_pos = crow_v2.global_position - direccion * rango_objetivo
	mover_owl_v2_hacia(nuevo_pos)

# Función para manejar la reproducción de sonidos.
func manejar_sonido(sonido_a_reproducir, sonido_a_detener):
	if !sonido_a_reproducir.playing:
		sonido_a_reproducir.play()
	sonido_a_detener.stop()

# Función para detener todos los sonidos.
func detener_sonidos():
	sonido_rango_max.stop()
	sonido_rango_min.stop()

# Función para actualizar la animación de owl_v2 según su movimiento.
func actualizar_animacion():
	# Calcula si owl_v2 se está moviendo.
	var velocidad_actual = owl_v2.global_position.distance_to(owl_pos_anterior) / get_process_delta_time()
	
	# Ajusta el parámetro del BlendSpace1D.
	if velocidad_actual > 0.1:  # Si owl_v2 se está moviendo (velocidad significativa).
		owl_animation_tree.set("parameters/Locomotion/blend_position", 1.0)  # Cambia a "walk".
	else:  # Si no se mueve.
		owl_animation_tree.set("parameters/Locomotion/blend_position", 0.0)  # Cambia a "idle".

	# Actualiza la posición anterior.
	owl_pos_anterior = owl_v2.global_position

# Método para registrar si el jugador está controlando owl_v2.
func set_jugador_moviendo(esta_moviendo: bool):
	jugador_moviendo = esta_moviendo
