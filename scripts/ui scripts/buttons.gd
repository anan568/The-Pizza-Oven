extends Control

var lv = ["res://scenes/levels/better_main_menu.tscn",
"res://scenes/levels/lv 0, pt corp.tscn"]

@onready var play_button = $"hat chair"
@onready var settings_button = $"MICROPHONE" 

func _ready() -> void:
	for child in get_children():
		child.frame = 0

##play button
func _on_play_button_mouse_entered() -> void:
	play_button.frame = 1
	
func _on_play_button_mouse_exited() -> void:
	play_button.frame = 0
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(lv[1]) #add level selection? continue button? save file selection?

##settings button
func _on_settings_btuton_mouse_entered() -> void:
	settings_button.frame = 1

func _on_settings_btuton_mouse_exited() -> void:
	settings_button.frame = 0

func _on_settings_btuton_pressed() -> void:
	pass # Replace with function body.

##quit button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
