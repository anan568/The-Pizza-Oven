extends CharacterBody2D

var extra_gravity = 5
var acceleration_boost = 30
var friction = 5
var speed = 500
var flip_speed = 100
var acceleration = 15
var jump_height = 300
enum state{Patrol, Attack, Aggro}
var current_state = state.Patrol
@onready var sight = $Sight
var player
var facing_right := true
var direction = 1

@onready var animator = $animation
var attack_startup = 0.5
var attack_active = 0.4
var attack_lag = 0.4

var flipped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (gravity + extra_gravity) * delta
	
	if is_on_floor():
		flipped = false
		
	if current_state == state.Patrol:
		if (not $RayCast2D.is_colliding() or $wall_check.is_colliding()) and not flipped:
			flipped = true
			scale.x *= -1
			facing_right = !facing_right
			direction *= -1
			if is_on_floor(): Sick_Flip()
			if not is_on_floor(): velocity.x *= direction
			
		if $RayCast2D.is_colliding():
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)
		
	if current_state == state.Attack or current_state == state.Aggro:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration + acceleration_boost)
		
	if current_state == state.Attack or current_state == state.Aggro:
		if (not $RayCast2D.is_colliding() or $wall_check.is_colliding()) and is_on_floor():
			scale.x *= -1
			facing_right = !facing_right
			direction *= -1
			Sick_Flip()
		
		if velocity.x > 300 or velocity.x < -300:
			$hitbox.monitoring = true
		
		elif velocity.x <= 300 or velocity.x >= -300:
			$hitbox.monitoring = false
		
		if is_on_floor():
			$"bullet destroy/Sprite2D".visible = false
			$"bullet destroy".monitoring = false
			Skate_Launch()
		elif not is_on_floor():
			$"bullet destroy/Sprite2D".visible = true
			$"bullet destroy".monitoring = true
			
	if velocity.x > 0 and not facing_right:
		scale.x *= -1
		facing_right = !facing_right
		
	if velocity.x < 0 and facing_right:
		scale.x *= -1
		facing_right = !facing_right
	
	velocity.x = move_toward(velocity.x, 0, friction)
	
	move_and_slide()
	
func Sick_Flip():
	velocity.x = flip_speed * direction
	if is_on_floor():
		velocity.y -= jump_height
		
func Skate_Launch():
	if player.global_position.x > global_position.x:
		direction = 1
	if player.global_position.x < global_position.x:
		direction = -1
		
	await get_tree().create_timer(attack_startup).timeout
	if is_on_floor():
		velocity.y -= jump_height
