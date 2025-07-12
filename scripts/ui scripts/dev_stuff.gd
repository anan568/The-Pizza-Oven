extends Node2D

@onready var dev_menu = $"dev menu"
signal console_opened
signal console_closed
var devving = false

func _ready():
	dev_menu.set_process(false)
	dev_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dev_console") and not devving:
		dev_menu.set_process(true)
		dev_menu.visible = true
		devving = true
		console_opened.emit()
		
	elif Input.is_action_just_pressed("dev_console") and devving:
		dev_menu.set_process(false)
		dev_menu.visible = false
		devving = false
		console_closed.emit()
