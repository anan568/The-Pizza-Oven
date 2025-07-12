extends Control

@onready var health_bar = $"Health Bar"
@export var player: Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = player.current_health
	$"Health Bar/Label".text = str(player.current_health)
