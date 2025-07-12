extends Area2D

var damage = 20
var h_kb = 500
var v_kb = 500

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.Take_Damage(damage)
		
		$"..".direction *= -1
		
		if $"..".facing_right:
			body.velocity += Vector2(h_kb, -v_kb)
		else:
			body.velocity += Vector2(-h_kb, -v_kb)
