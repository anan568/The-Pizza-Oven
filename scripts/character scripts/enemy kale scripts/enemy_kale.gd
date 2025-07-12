extends CharacterBody2D

var push_force = 18
var friction = 10
var speed = 200
enum state{Patrol, Attack, Aggro}
var current_state = state.Patrol
@onready var sight = $Sight
var player
var on_cooldown:= false
var facing_right := true
var direction = 1

@onready var animator = $animation
var attack_startup = 0.3
var attack_active = 0.1
var attack_lag = 0.4

var clear

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	player = get_tree().current_scene.get_node("Game").player

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position, 0b100, [self])
	var result = space_state.intersect_ray(query)
	
	if result.size() == 0:
		clear = true
	else:
		clear = false
	
	if not on_cooldown:
		if velocity.y == 0:
			if velocity.x == 0:
				animator.play("idle")
			else:
				animator.play("run")
				
		if (current_state != state.Attack or current_state == state.Attack and not clear) and $"pizza check".is_colliding():
			var pizza = $"pizza check".get_collider(0)
			var pizzaquery = PhysicsRayQueryParameters2D.create(global_position, pizza.global_position, 0b100, [self])
			var pizzaresult = space_state.intersect_ray(pizzaquery)
			if pizzaresult.size() == 0:
				Punch(pizza)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if current_state == state.Patrol or not clear:
		if not $RayCast2D.is_colliding() or $wall_check.is_colliding():
			TurnAround()
			
	if current_state == state.Aggro and not on_cooldown and clear:
		if player.global_position.x > global_position.x and not facing_right:
			TurnAround()
		
		elif player.global_position.x < global_position.x and facing_right:
			TurnAround()
		
	if current_state == state.Attack and not on_cooldown and is_on_floor() and clear:
		Punch(player)
	
	velocity.x = move_toward(velocity.x, 0, friction)
	
	if not on_cooldown:
		if $RayCast2D.is_colliding():
			velocity.x = speed * direction
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is RigidBody2D:
			var p_velocity = collider.linear_velocity
			if Vector2(absf(p_velocity.x), absf(p_velocity.y)) < Vector2(200, 200):
				collider.apply_central_impulse(-get_slide_collision(i).get_normal() * push_force * Vector2(2, 0.5))
	
func TurnAround():
	scale.x *= -1
	facing_right = !facing_right
	direction *= -1

func Punch(target: Node):
	on_cooldown = true
	animator.play("winding")
	$"worm punch".look_at(target.position)
	await get_tree().create_timer(attack_startup).timeout
	animator.play("punch")
	$"worm punch".monitoring = true
	$"worm punch/Worm".visible = true
	await get_tree().create_timer(attack_active).timeout
	$"worm punch".monitoring = false
	$"worm punch/Worm".visible = false
	animator.play("reset")
	await get_tree().create_timer(attack_lag).timeout
	on_cooldown = false
