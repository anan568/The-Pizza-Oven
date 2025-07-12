extends Node2D

@onready var elevator = $"Pizza Elevator"
var destination = [Vector2(0, 0), Vector2(0, -245), Vector2(0, -500)]
var target_floor = Vector2(0, 0)
var next_floor = 0
var speed = 5
var reached = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if reached: return
	var direction = elevator.position.direction_to(target_floor)
	elevator.position += direction * speed
	if is_equal_approx(elevator.position.y, target_floor.y):
		reached = true
		await get_tree().create_timer(0.1).timeout
		$"Pizza Elevator/CollisionShape2D".one_way_collision = true

func _on_trigger_interacted():
	next_floor += 1
	if next_floor == 3:
		next_floor = 0
	target_floor = destination[next_floor]
	$"Pizza Elevator/CollisionShape2D".one_way_collision = false
	reached = false
