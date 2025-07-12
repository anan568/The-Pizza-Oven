extends Node2D

var weapon_container = preload("res://scenes/systems/weapon_container.tscn")
var main_weapon: Node2D
var secondary_weapon: Node2D
var middle_weapon: Node2D

@onready var pickup_range = $"../PJ Pizzamaker/pickup range"
@onready var spin_spin = $"../PJ Pizzamaker/spin spin"
@onready var second_weapon_holder = $"../PJ Pizzamaker/second weapon"
@onready var arm = $"../PJ Pizzamaker/spin spin/arm"

func _ready():
	if main_weapon == null:
		arm.Unarmed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("swap_weapon"):
		Swap()
		
	if Input.is_action_just_pressed("pick_up"):
		if pickup_range.is_colliding():
			Pick_Up(pickup_range.get_collider(0).get_child(2))
			
	if Input.is_action_just_pressed("drop_weapon"):
		Drop()
		
func Swap():
	if main_weapon != null:
		main_weapon.set_process(false)
		
	second_weapon_holder.remove_child(secondary_weapon)
	spin_spin.remove_child(main_weapon)
	second_weapon_holder.add_child(main_weapon)
	spin_spin.add_child(secondary_weapon)
	
	middle_weapon = secondary_weapon
	secondary_weapon = main_weapon
	main_weapon = middle_weapon
	
	await get_tree().process_frame
	if main_weapon != null:
		arm.Armed()
		main_weapon.set_process(true)
		main_weapon.Update_Ammo()
		
	if main_weapon == null:
		arm.Unarmed()
	
func Pick_Up(weapon: Node2D):
	if main_weapon != null:
		Drop()
		await get_tree().process_frame

	main_weapon = weapon
	var parent = main_weapon.get_parent()
	if parent.is_in_group("weapon_container"):
		parent.remove_child(weapon)
		parent.queue_free()
	else:
		parent.call_deferred("remove_child", weapon)
		
	spin_spin.call_deferred("add_child", main_weapon)
	main_weapon.position = Vector2(16, -2)
	main_weapon.rotation = deg_to_rad(0)
	main_weapon.set_process(true)
	main_weapon.Update_Ammo()
	arm.Armed()
		
func Drop():
	if main_weapon == null: return
	
	var parent = main_weapon.get_parent()
	main_weapon.set_process(false)
	parent.call_deferred("remove_child", main_weapon)
	await get_tree().process_frame
	
	var instance = weapon_container.instantiate()
	instance.global_position = parent.global_position
	instance.add_child(main_weapon)
	get_tree().current_scene.add_child(instance)
	main_weapon.position = Vector2(0, 0)
	main_weapon = null
	arm.Unarmed()
