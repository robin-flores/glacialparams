extends Control

var fade_rect: ColorRect
var video_player: VideoStreamPlayer
var is_fading: bool = false
var intro_finished: bool = false  

func _ready():
	fade_rect = $FadeRect
	video_player = $AspectRatioContainer/VideoPlayer
	
	fade_rect.color.a = 0  
	fade_rect.visible = false  

	video_player.stop()

	$VBoxContainer/startButton.grab_focus()
	$VBoxContainer/startButton.pressed.connect(self._on_start_button_pressed)

func _process(delta: float) -> void:

	if is_fading:
		if fade_rect.color.a < 1:
			fade_rect.color.a += delta * 0.5 
		else:
			if not intro_finished:
				video_player.play()
				intro_finished = true

	if intro_finished and !video_player.is_playing():
		get_tree().change_scene_to_file("res://Scenes/forest.tscn")

func _on_start_button_pressed() -> void:
	fade_rect.visible = true
	is_fading = true
	$VBoxContainer.hide()
	
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
