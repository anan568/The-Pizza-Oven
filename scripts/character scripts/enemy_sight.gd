extends Area2D

@onready var enemy = $".."

func _on_body_entered(body):
	if body.is_in_group("player"):
		enemy.current_state = enemy.state.Attack
		enemy.player = body


func _on_body_exited(body):
	if body.is_in_group("player"):
		enemy.current_state = enemy.state.Aggro
