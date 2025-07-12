extends Node2D

@export var health = 80
var main
var current_health

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_health <= 0:
		$"..".queue_free()
	
func damaged(damage : int) -> void:
	current_health -= damage
	$"..".current_state = $"..".state.Aggro
