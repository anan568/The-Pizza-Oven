extends StaticBody2D

@onready var trigger = $trigger
@onready var swag_text = preload("res://scenes/ui scenes/swag_text.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	trigger.connect("Interacted", Interacted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Interacted():
	var instance = swag_text.instantiate()
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)
