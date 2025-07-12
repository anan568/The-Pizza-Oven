extends Area2D

var crankable = false
var crank_speed = 5
var crank = 0
var direction = 1
var elevator_speed = 100

func _physics_process(delta: float) -> void:
	if not is_equal_approx($VentCrank.rotation_degrees, crank * 45):
		$"..".global_position.y += elevator_speed * direction * delta
	else:
		$"../CollisionShape2D".one_way_collision = true
	$VentCrank.rotation_degrees = move_toward($VentCrank.rotation_degrees, crank * 45, crank_speed)
	
func _process(delta: float) -> void:
	if $"../groundcheck".is_colliding():
		direction = -1
	if $"../ceilingcheck".is_colliding():
		direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire1") and crankable:
		crank += 1
		$"../CollisionShape2D".one_way_collision = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		crankable = true

	#make text that says m1 to crank
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		crankable = false
