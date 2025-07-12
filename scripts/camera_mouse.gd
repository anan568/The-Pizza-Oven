extends Camera2D

func _physics_process(delta):
	var mouse_offset = (get_viewport().get_mouse_position() - Vector2(get_viewport().size) / 2)
	position = lerp(Vector2(), mouse_offset.normalized() * 250, mouse_offset.length() / 1000)
	
