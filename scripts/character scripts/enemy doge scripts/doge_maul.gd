extends Area2D

var damage = 20
var knockback = 350
var claw = preload("res://scenes/gfx scenes/claw_effect.tscn")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.Take_Damage(damage)
		set_deferred("monitoring", false)
		$slash.visible = false
		if global_position > body.global_position:
			body.velocity.x -= knockback
			
		else:
			body.velocity.x += knockback


func _on_area_entered(area):
	if area.is_in_group("bullet"):
		var instance = claw.instantiate()
		instance.global_position = area.global_position
		instance.scale = Vector2(0.7, 0.7)
		if not $"..".facing_right:
			instance.scale.x *= -1
		get_tree().root.add_child(instance)
		area.queue_free()
