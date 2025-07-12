extends Area2D

@onready var text = $Panel
var interactable = false
signal Interacted

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _physics_process(delta):
	if not interactable: return
	if Input.is_action_just_pressed("use"):
		Interacted.emit()

func _on_body_entered(body):
	if body.is_in_group("player"):
		interactable = true
	if not interactable: return
	text.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		interactable = false
		text.visible = false
