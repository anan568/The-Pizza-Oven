extends CharacterBody2D

@export var threshold: int = 500
var last_ground_pos

var max_health = 100
var current_health

var fast_fall_speed = 20
var speed = 250.0
var bhopspeed = 0
var bhopfriction = 10
var jump_force = -250.0
var super_duper_double_jumps: int = 1
var double_jumps: int
var friction = 30
var acceleration = 30
var wall_jump_force = 350
var wall_gravity = 130
var slide = false
var slide_speed = 350
var slide_direction
var ready_to_stand = false

var push_force = 18
var slide_push_force = 200

var max_pizza = 3

@onready var pizza_maker = $"spin spin"/"make pizza"
@onready var animated_sprite = $AnimatedSprite2D
@onready var spin_spin = $"spin spin"
@onready var stand_check = $"Stand Check"
var making_that_bread: bool = false
@onready var head = $head/Sprite2D
@onready var normal_collision = $"Normal Collision"
@onready var slide_collision = $"Slide Collision"
@onready var headlol = $head
@onready var default_head_pos = headlol.position
@onready var default_spin_pos = spin_spin.position
var facingRight: bool = true

var fast_falling = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pizza_maker.connect("making_pizza", making_pizza)
	pizza_maker.connect("pizza_made", done_pizza)
	double_jumps = super_duper_double_jumps
	current_health = max_health
	
func making_pizza() -> void:
	making_that_bread = true
	animated_sprite.play("make pizza")
	head.visible = false
	spin_spin.visible = false
	
func done_pizza() -> void:
	making_that_bread = false
	head.visible = true
	spin_spin.visible = true

func _process(delta):
	var mousePos = get_global_mouse_position().x
	if mousePos > position.x && !facingRight and not slide:
		facingRight = true
		scale.x *= -1

	if mousePos < position.x && facingRight and not slide:
		facingRight = false
		scale.x *= -1
		
	if current_health <= 0:
		Die()

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if threshold < global_position.y:
		global_position = last_ground_pos
		Take_Damage(30)
	
	# Add the gravity.
	if not is_on_floor():
		if not fast_falling:
			velocity.y += gravity * delta
			
		elif fast_falling:
			velocity.y += gravity * delta + fast_fall_speed
			
		if is_on_wall() and velocity.y > 0:
			velocity.y = min(velocity.y, wall_gravity)
			
		if Input.is_action_just_pressed("crouch"):
			fast_falling = true
		if Input.is_action_just_released("crouch"):
			fast_falling = false
		
	if is_on_floor():
		fast_falling = false
		double_jumps = super_duper_double_jumps
		bhopspeed = move_toward(bhopspeed, 0, bhopfriction)
		
		if $pizza_check.is_colliding() and not $pizza_check.get_collider() == null and not $pizza_check.get_collider().is_in_group("pizza_platform"):
			pizza_maker.pizza_left = max_pizza
			last_ground_pos = global_position
		
	if Input.is_action_just_pressed("jump") and is_on_wall() and not is_on_floor():
		velocity.y = jump_force
		velocity.x = wall_jump_force * get_wall_normal().x
		double_jumps = super_duper_double_jumps
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !slide:
		velocity.y = jump_force
		bhopspeed += 40
		
	if Input.is_action_just_pressed("crouch") and is_on_floor() and direction != 0 and not slide:
		slide_direction = direction
		Slide()

	if ready_to_stand and not stand_check.is_colliding():
		Stand_Up()

	if slide and $"headbutt check".get_collider() != null and not $"headbutt check".get_collider().is_in_group("pizza_platform"):
		scale.x *= -1
		facingRight = !facingRight
		slide_direction *= -1
		
	if Input.is_action_just_pressed("jump") and not is_on_floor() and double_jumps != 0 and not is_on_wall():
		if not stand_check.is_colliding():
			Stand_Up()
		double_jumps -= 1
		velocity.y = jump_force
		
	if velocity.y < 0 and not is_on_floor() and not making_that_bread and not slide:
		animated_sprite.play("jump")
		
	if velocity.y > 0 and not is_on_floor() and not making_that_bread and not slide:
		animated_sprite.play("fall")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if not slide:
		if direction:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * speed, acceleration)
			elif not is_on_floor():
				velocity.x = move_toward(velocity.x, direction * (speed + bhopspeed), acceleration)
	if !direction and not slide:
		velocity.x = move_toward(velocity.x, 0, friction)
	
	if slide:
		velocity.x = move_toward(velocity.x, slide_direction * slide_speed, acceleration * 2)
	
	if not making_that_bread:
		if direction == 0 and is_on_floor() and !slide:
			animated_sprite.play("idle")
			
		elif direction != 0 and is_on_floor() and !slide:
			animated_sprite.play("walk")

	move_and_slide()
	
	#pizza push
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is RigidBody2D:
			var p_velocity = collider.linear_velocity
			if Vector2(absf(p_velocity.x), absf(p_velocity.y)) < Vector2(200, 200):
				if not slide:
					collider.apply_central_impulse(-get_slide_collision(i).get_normal() * push_force * Vector2(2, 0.5))
				if slide:
					collider.apply_central_impulse(-get_slide_collision(i).get_normal() * slide_push_force * Vector2(2, 0.5))
			
	
func Stand_Up():
	slide = false
	normal_collision.disabled = false
	slide_collision.disabled = true
	spin_spin.position = default_spin_pos
	headlol.position = default_head_pos
	ready_to_stand = false

func Slide():
	if making_that_bread: return
	slide = true
	if slide_direction > 0 and not facingRight:
		scale.x *= -1
		facingRight = true
	elif slide_direction < 0 and facingRight:
		scale.x *= -1
		facingRight = false
		
	await get_tree().process_frame
	headlol.position = $"Slide Head Position".position
	spin_spin.position = $"Slide Arm Position".position
	animated_sprite.play("slide")
	slide_collision.set_deferred("disabled", false)
	await get_tree().process_frame
	normal_collision.set_deferred("disabled", true)
	await get_tree().create_timer(0.3).timeout
	ready_to_stand = true

func Take_Damage(damage: int):
	current_health -= damage
	
func Die():
	get_tree().reload_current_scene()
