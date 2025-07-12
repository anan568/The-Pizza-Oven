extends Area2D

@export var text: MarginContainer
var interactable = false
signal Interacted

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		text.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		text.visible = false
