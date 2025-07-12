extends MarginContainer

@export var initial_text: String
@export var max_width = 256

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/Label.text = initial_text
	await resized
	custom_minimum_size.x = min(size.x, max_width)
	
	if size.x > max_width:
		$MarginContainer/Label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
