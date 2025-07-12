extends RichTextLabel

var float_rate = 0.5
var vanish_rate = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y -= float_rate
	modulate.a -= vanish_rate * delta
