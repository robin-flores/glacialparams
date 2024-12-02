extends Node

@export var rango_maximo: float = 10.0  # Rango máximo en metros.
@export var rango_minimo: float = 2.0   # Rango mínimo en metros.

@onready var crow_v2 = get_node("../crow_v2")  # Ruta relativa para encontrar a crow_v2.
@onready var owl_v2 = get_node("../owl_v2")  # Ruta relativa para encontrar a owl_v2.
@onready var sonido_rango_max = crow_v2.get_node("Worried_AudioStreamPlayer3D")  # Sonido para rango máximo.
@onready var sonido_rango_min = crow_v2.get_node("Angry_AudioStreamPlayer3D")  # Sonido para rango mínimo.

# Función que verifica la distancia y maneja los sonidos.
func _process(_delta):
	var distancia = crow_v2.global_position.distance_to(owl_v2.global_position)

	if distancia > rango_maximo:
		manejar_sonido(sonido_rango_max, sonido_rango_min)  # Activar sonido máximo.
		mover_owl_v2_a_rango(rango_maximo)
	elif distancia < rango_minimo:
		manejar_sonido(sonido_rango_min, sonido_rango_max)  # Activar sonido mínimo.
		mover_owl_v2_a_rango(rango_minimo)
	else:
		detener_sonidos()  # Detener ambos sonidos si está dentro del rango permitido.

# Función que ajusta la posición de owl_v2 dentro de los rangos.
func mover_owl_v2_a_rango(rango_objetivo):
	var direccion = (crow_v2.global_position - owl_v2.global_position).normalized()
	var nuevo_pos = crow_v2.global_position - direccion * rango_objetivo
	owl_v2.global_position = nuevo_pos

# Función para manejar la reproducción de sonidos.
func manejar_sonido(sonido_a_reproducir, sonido_a_detener):
	if !sonido_a_reproducir.playing:
		sonido_a_reproducir.play()
	sonido_a_detener.stop()

# Función para detener todos los sonidos.
func detener_sonidos():
	sonido_rango_max.stop()
	sonido_rango_min.stop()
