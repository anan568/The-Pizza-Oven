extends Sprite2D

@export var timer: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(timer).timeout
	queue_free()
