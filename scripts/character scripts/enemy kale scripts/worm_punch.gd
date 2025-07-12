extends Area2D

var damage = 30
var force = 600
var pizzaforce = 1200

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.Take_Damage(damage)
		body.velocity = Vector2(force, 0).rotated(global_position.angle_to_point(body.global_position))
		
	if body.is_in_group("pizza_platform"):
		body.apply_impulse(Vector2(pizzaforce, 0).rotated(global_position.angle_to_point(body.global_position)))
		body.explode_triggered()
