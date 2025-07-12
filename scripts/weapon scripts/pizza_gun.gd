extends Node2D

var clip_size = 10
var reload_speed = 0.5
var bullet_speed = 15
var bullet_damage = 10
var bullet_force = 30
var current_ammo
var reloading = false
var devving = false
@onready var firePoint : Marker2D = $firePoint
@export var ammo_counter: Control
var clip_sprite = preload("res://sprites/weapons/ammo/bullet clip.png")
var bullet = preload("res://scenes/weapon scenes/ammo scenes/pizza_bullet.tscn")
@export var pizza_maker: Node2D

func _ready():
	if get_parent().name != "spin spin":
		set_process(false)
	current_ammo = clip_size
	
func _physics_process(delta: float) -> void:
	if reloading:
		rotation = move_toward(rotation, deg_to_rad(720), 0.42)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if devving: return
	if is_equal_approx(rad_to_deg(rotation), 720) and not reloading:
		rotation = 0
	if Input.is_action_just_pressed("fire1") and current_ammo > 0 and not reloading and not pizza_maker.already_making:
		current_ammo -= 1
		var instance = bullet.instantiate()
		var direction = global_position.angle_to_point(get_global_mouse_position())
		instance.position = firePoint.global_position
		instance.rotation = direction
		instance.speed = bullet_speed
		instance.damage = bullet_damage
		instance.force = bullet_force
		get_tree().current_scene.add_child(instance)
		Update_Ammo()
		
	if Input.is_action_just_pressed("reload") and not reloading and not pizza_maker.already_making:
		reloading = true
		await get_tree().create_timer(reload_speed).timeout
		reloading = false
		current_ammo = clip_size
		Update_Ammo()
		
func Update_Ammo():
	ammo_counter.Update_Ammo(current_ammo, clip_size, clip_sprite)

func _on_game_console_opened():
	devving = true

func _on_game_console_closed():
	devving = false
