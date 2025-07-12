extends CharacterBody2D

var push_force = 25
var friction = 10
var speed = 140
var fart_speed = 400
var jump_height = 300
enum state{Patrol, Attack, Aggro}
var current_state = state.Patrol
@onready var sight = $Sight
var player
var on_cooldown:= false
var facing_right := true
var direction = 1

@onready var animator = $animation
var attack_startup = 0.2
var attack_active = 0.4
var attack_lag = 0.4

var clear

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	player = get_tree().current_scene.get_node("Game").player

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position, 0b100, [self])
	query.exclude
	var result = space_state.intersect_ray(query)
	
	if result.size() == 0:
		clear = true
	else:
		clear = false
	
	if not on_cooldown and (current_state == state.Aggro or current_state == state.Attack):
		animator.play("aggressive")
	if current_state == state.Patrol:
		animator.play("neutral")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if current_state == state.Patrol or not clear:
		if not $RayCast2D.is_colliding() or $wall_check.is_colliding():
			scale.x *= -1
			facing_right = !facing_right
			direction *= -1
			
		if $RayCast2D.is_colliding():
			velocity.x = speed * direction
		
	if (current_state == state.Attack or current_state == state.Aggro) and not on_cooldown and is_on_floor() and clear:
		Lunge()
			
	if velocity.x > 0 and not facing_right:
		scale.x *= -1
		facing_right = !facing_right
		direction *= -1
		
	if velocity.x < 0 and facing_right:
		scale.x *= -1
		facing_right = !facing_right
		direction *= -1
	
	velocity.x = move_toward(velocity.x, 0, friction)
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is RigidBody2D:
			var p_velocity = collider.linear_velocity
			if Vector2(absf(p_velocity.x), absf(p_velocity.y)) < Vector2(200, 200):
				collider.apply_central_impulse(-get_slide_collision(i).get_normal() * push_force * Vector2(2, 0.5))
	
func Lunge():
	on_cooldown = true
	animator.play("squat")
	await get_tree().create_timer(attack_startup).timeout
	animator.play("lunge")
	$"maul hitbox".monitoring = true
	$"maul hitbox/slash".visible = true
	velocity = global_position.direction_to(player.position) * fart_speed
	velocity.y -= jump_height
	await get_tree().create_timer(attack_active).timeout
	animator.play("aggressive")
	$"maul hitbox".monitoring = false
	$"maul hitbox/slash".visible = false
	
	await get_tree().create_timer(attack_lag).timeout
	on_cooldown = false
