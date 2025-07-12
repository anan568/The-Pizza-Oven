extends StaticBody2D

@onready var trigger = $trigger
@export var door: Sprite2D
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	trigger.connect("Interacted", Interacted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Interacted():
	if not opened:
		door.frame = 1
		$CollisionShape2D.disabled = true
		opened = true
		
	elif opened:
		door.frame = 0
		$CollisionShape2D.disabled = false
		opened = false
