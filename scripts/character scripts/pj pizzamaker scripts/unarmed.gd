extends Sprite2D

var force = 350
var damage = 10
var unarmed
var active = false
var punched = false
var right_punch = true
var active_frames = 0
@export var ammo_counter: Control
@onready var hitbox = $hitbox
@onready var player = $"../.."

func _process(delta):
	if hitbox.is_colliding() and not punched:
		var collider = hitbox.get_collider()
		if collider.is_in_group("pizza_platform"):
			if player.facingRight:
				collider.apply_impulse(Vector2(force, 0).rotated(rotation))
			if not player.facingRight:
				collider.apply_impulse(Vector2(force, 0).rotated(rotation + deg_to_rad(180)))
				
			collider.explode_triggered()
			punched = true
			
		if collider.is_in_group("enemy"):
			collider.get_node("health").damaged(damage)
			punched = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active and unarmed:
		active_frames += delta
		
	if active_frames >= 0.1 and unarmed:
		active = false
		punched = false
		frame = 1
		hitbox.enabled = false
		
	if Input.is_action_just_pressed("fire1") and unarmed:
		active_frames = 0
		active = true
		punched = false
		Punch()
		
func Punch():
	if right_punch:
		frame = 2
		hitbox.enabled = true
		right_punch = false
	else:
		right_punch = true
		frame = 3
		hitbox.enabled = true

func Unarmed():
	ammo_counter.Unarmed()
	unarmed = true
	frame = 1
	
func Armed():
	unarmed = false
	frame = 0
	active_frames = 0
	active = false
