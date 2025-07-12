extends Node2D

var pizza_platform = preload("res://scenes/weapon scenes/ammo scenes/pizza_platform.tscn")
var already_making: bool = false
var pizza_left = 3
var explode_time = 0.8
var explosion_force = 3
var explosion_damage = 20
var enemy_damage_multiplier = 2
var insta_explode = false
@export var player: CharacterBody2D
signal making_pizza
signal pizza_made
	
func _input(event):
	if event.is_action_pressed("fire2") and not already_making and pizza_left > 0 and not player.slide:
		making_pizza.emit()
		pizza_left -= 1
		already_making = true
		
		await get_tree().create_timer(0.2).timeout
		
		already_making = false
		pizza_made.emit()
		var instance = pizza_platform.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = global_position
		instance.rotation = global_rotation - deg_to_rad(90)
		instance.explode_time = explode_time
		instance.explosion_force = explosion_force
		instance.explosion_damage = explosion_damage
		instance.insta_explode = insta_explode
		instance.enemy_damage_multiplier = enemy_damage_multiplier
