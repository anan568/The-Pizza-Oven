extends Area2D

var velocity
var explosion_force
var explosion_damage
var insta_explode
var enemy_damage_multiplier
var damaged = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy") and not damaged:
			damaged = true
			body.get_node("health").damaged(explosion_damage * enemy_damage_multiplier)
			body.velocity = Vector2(150 + absf(velocity.x)/2, 0).rotated(global_position.angle_to_point(body.global_position))
			 
		if body.is_in_group("pizza_platform"):
			if insta_explode:
				body.explode()
			body.apply_force(Vector2(max(8 * absf(velocity.x), 800), 0).rotated(global_position.angle_to_point(body.global_position)) * explosion_force)
			body.explode_triggered()
			
		if body.is_in_group("player") and not damaged:
			damaged = true
			body.Take_Damage(explosion_damage)
			body.double_jumps = body.super_duper_double_jumps
			body.velocity = Vector2(150 + absf(velocity.x)/2, 0).rotated(global_position.angle_to_point(body.global_position)) * explosion_force
