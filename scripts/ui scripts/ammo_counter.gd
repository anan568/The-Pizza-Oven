extends Control
var unarmed_sprite = preload("res://sprites/UI/unarmed display.png")

func Update_Ammo(ammo: int, max_ammo: int, sprite: Resource):
	$Label.text = str(ammo) + "/" + str(max_ammo)
	$Sprite2D.texture = sprite
	
func Unarmed():
	$Sprite2D.texture = unarmed_sprite
	$Label.text = "BALL!"
