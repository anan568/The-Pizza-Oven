extends Sprite2D
var i = 0
var u = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	i += delta
	u += delta
	
	if i >= 1:
		$ClockkMinute.rotate(deg_to_rad(6))
		i = 0
		
	if u >= 3:
		$ClockkHour.rotate(deg_to_rad(1.5))
		u = 0
