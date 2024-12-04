extends Control


func _ready():
	$VBoxContainer/startButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/forest.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
