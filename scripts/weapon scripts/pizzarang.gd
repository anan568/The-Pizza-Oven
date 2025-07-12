extends Area2D

var time_airborne = 0
var air_time_multiplier = 20
var lethal = false
var flying = false
var fly_back = false
var flight_time = 0.5
var speed = 10
var rotate_speed = 0.8
var enemy_damage = 25
var player_damage = 5
var max_ammo = 1
var current_ammo
var ammo_sprite = preload("res://sprites/weapons/pizzarang.png")
var pizza_platform_sprite = preload("res://sprites/weapons/ammo/pizza platform.png")

var explosion = preload("res://scenes/weapon scenes/ammo scenes/pizza_explosion.tscn")
var explode_time = 0.8
var explosion_force = 4
var explosion_damage = 20
var enemy_damage_multiplier = 2
var insta_explode = false
var devving = false

@onready var root  = get_tree().current_scene

@export var ammo_counter: Control
@export var pizza_maker: Node2D
@export var player: Node2D
@export var weapon_system: Node2D
var weapon_container = preload("res://scenes/systems/weapon_container.tscn")

func _ready():
	if get_parent().name != "spin spin":
		set_process(false)
	current_ammo = max_ammo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if devving: return
	
	if current_ammo > 0:
		flying = false
		fly_back = false
	
	if Input.is_action_just_pressed("fire1") and current_ammo > 0 and not pizza_maker.already_making:
		Launch()
		$"cheese drip".emitting = true
		lethal = true
		time_airborne = 0
		
	if Input.is_action_just_pressed("fire1") and fly_back and not pizza_maker.already_making:
		lethal = false
		
func _physics_process(delta):
	if flying:
		time_airborne += delta
		position += transform.x * speed
		$Sprite2D.rotation += rotate_speed
		
	if fly_back:
		look_at(player.global_position)
		
func Update_Ammo():
	ammo_counter.Update_Ammo(current_ammo, max_ammo, ammo_sprite)

func _on_game_console_opened():
	devving = true

func _on_game_console_closed():
	devving = false

func Launch():
	weapon_system.main_weapon = null
	current_ammo -= 1
	var launch_pos = global_position
	var parent_rot = get_parent().rotation
	get_parent().call_deferred("remove_child", self)
	await get_tree().process_frame
	
	root.add_child(self)
	if player.facingRight:
		rotation = parent_rot
	else:
		rotation = -parent_rot + deg_to_rad(180)
		
	global_position = launch_pos
	flying = true
	Update_Ammo()
	
	await get_tree().create_timer(flight_time).timeout
	fly_back = true

func _on_body_entered(body):
	if not flying: return
	if body.is_in_group("ground"):
		fly_back = true
	
	if get_children() != null:
			for child in $Sprite2D.get_children():
				explode(child)
				
	if body.is_in_group("player") and fly_back:
		$"cheese drip".emitting = false
		if lethal:
			body.Take_Damage(player_damage + time_airborne * air_time_multiplier)
			
		if weapon_system.main_weapon != null:
			flying = false
			fly_back = false
			if not lethal:
				body.Take_Damage(player_damage + time_airborne * air_time_multiplier)
			get_parent().call_deferred("remove_child", self)
			await get_tree().process_frame
			var instance = weapon_container.instantiate()
			instance.global_position = global_position
			instance.add_child(self)
			root.add_child(instance)
			position = Vector2(0, 0)
			current_ammo = max_ammo
		
		else:
			weapon_system.Pick_Up(self)
			flying = false
			fly_back = false
			current_ammo = max_ammo
			
		Update_Ammo()
	
	if body.is_in_group("enemy"):
		get_node(body.get_path()).get_node("health").damaged(enemy_damage)
		
	if body.is_in_group("pizza_platform") and flying:
		body.queue_free()
		var instance = Sprite2D.new()
		instance.scale = Vector2(0.7, 0.7)
		instance.texture = pizza_platform_sprite
		$Sprite2D.add_child(instance)

func explode(pizza_platform: Node2D):
	var instance = explosion.instantiate()
	get_tree().root.call_deferred("add_child", instance)
	instance.position = pizza_platform.global_position
	instance.velocity = Vector2(200, 1)
	instance.insta_explode = insta_explode
	instance.explosion_force = explosion_force
	instance.explosion_damage = explosion_damage
	instance.enemy_damage_multiplier = enemy_damage_multiplier
	pizza_platform.queue_free()
