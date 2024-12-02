extends Node

#Variables Cambiables
@export_category("Variables")
@export var max_rango: float = 10.0  
@export var min_rango: float = 2.0   
@export var folllow_speed: float = 3.0  

#Variables Importadas
@onready var crow_v2 = get_node("../crow_v2") 
@onready var owl_v2 = get_node("../owl_v2")  
@onready var worried_max = crow_v2.get_node("Worried_AudioStreamPlayer3D") 
@onready var angry_min = crow_v2.get_node("Angry_AudioStreamPlayer3D") 
@onready var anim_owl = owl_v2.get_node("AnimationTree") 

#Guardar posicion Owl para calculos posteriores
var owl_og_pose: Vector3  


func _process(_delta):
	var distancia = crow_v2.global_position.distance_to(owl_v2.global_position)

	if distancia > max_rango:
		manejar_sonido(worried_max, angry_min)  
		move_owl_new(crow_v2.global_position)
	elif distancia < min_rango:
		manejar_sonido(angry_min, worried_max)  
		move_owl_rango(min_rango)
	else:
		detener_sonidos()  

	actualizar_animacion()


func move_owl_new(destino: Vector3):
	var direccion = (destino - owl_v2.global_position).normalized()
	owl_og_pose = owl_v2.global_position 
	owl_v2.global_position += direccion * folllow_speed * get_process_delta_time()

func move_owl_rango(obj_rango):
	var direccion = (crow_v2.global_position - owl_v2.global_position).normalized()
	var new_pose = crow_v2.global_position - direccion * obj_rango
	move_owl_new(new_pose)

func manejar_sonido(play_sonido, stop_sonido):
	if !play_sonido.playing:
		play_sonido.play()
	stop_sonido.stop()

func detener_sonidos():
	worried_max.stop()
	angry_min.stop()

func actualizar_animacion():
	var actual_speed = owl_v2.global_position.distance_to(owl_og_pose) / get_process_delta_time()
	
	if actual_speed > 0.1:  
		anim_owl.set("parameters/Locomotion/blend_position", 1.0) 
	else:  
		anim_owl.set("parameters/Locomotion/blend_position", 0.0) 

	owl_og_pose = owl_v2.global_position
