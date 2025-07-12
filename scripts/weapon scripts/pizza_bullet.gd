extends Area2D

var speed
var damage
var force

var hit_effect = preload("res://scenes/gfx scenes/hit_effect.tscn")

func _ready():
	await get_tree().create_timer(5).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed

func _on_body_entered(body):
	var hit_instance = hit_effect.instantiate()
	hit_instance.global_position = global_position
	hit_instance.scale = Vector2(0.5, 0.5)
	get_tree().root.add_child(hit_instance)
	
	if body.is_in_group("enemy"):
		var enemy_shit = get_node(body.get_path()).get_node("health")
		enemy_shit.damaged(damage)

	if body.is_in_group("bullet_breakable"):
		body.queue_free()
		
	if body.is_in_group("pizza_platform"):
		body.apply_force(Vector2(1000, 0).rotated(rotation) * force)
		body.explode_triggered()
		
	queue_free()
