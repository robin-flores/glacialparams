extends Node

@export_category("Variables")
@export var rango_maximo : float = 10.0  # Rango máximo en unidades.
@onready var crow_v2 = get_node("/root/Forest/crow_v2")  # Obtener referencia a crow_v2.
@onready var owl_v2 = get_node("/root/Forest/owl_v2")  # Obtener referencia a owl_v2.
@onready var sonido_alerta = crow_v2.get_node("AudioStreamPlayer3D")  # Nodo de sonido en crow_v2.

# Función que verifica la distancia.
func _process(delta):
	var distancia = crow_v2.global_position.distance_to(owl_v2.global_position)

	if distancia > rango_maximo:
		if !sonido_alerta.playing:  # Si el sonido no está sonando, lo reproduce.
			sonido_alerta.play()
		# Mandamos a owl_v2 de vuelta al rango.
		mover_owl_v2_a_rango()

# Función que hace que owl_v2 vuelva al rango.
func mover_owl_v2_a_rango():
	var direccion = (crow_v2.global_position - owl_v2.global_position).normalized()  # Dirección hacia crow_v2.
	var nuevo_pos = crow_v2.global_position - direccion * rango_maximo
	owl_v2.global_position = nuevo_pos
