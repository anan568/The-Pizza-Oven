extends RigidBody2D

var explosion = preload("res://scenes/weapon scenes/ammo scenes/pizza_explosion.tscn")
var explode_time
var explosion_force
var explosion_damage
var insta_explode
var enemy_damage_multiplier

func explode_triggered():
	await get_tree().create_timer(explode_time).timeout
	explode()

func explode():
	var instance = explosion.instantiate()
	get_tree().root.call_deferred("add_child", instance)
	instance.position = global_position
	instance.velocity = linear_velocity
	instance.insta_explode = insta_explode
	instance.explosion_force = explosion_force
	instance.explosion_damage = explosion_damage
	instance.enemy_damage_multiplier = enemy_damage_multiplier
	queue_free()
