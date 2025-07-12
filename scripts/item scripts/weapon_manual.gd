extends Node2D

var manual_sprite = preload("res://sprites/items/weapon manual/weapon manual paper.png")
@export var ammo_counter: Control

var helping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().name != "spin spin":
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("fire1") and not helping:
		$CanvasLayer/TextureRect.visible = true
		helping = true
		
	elif Input.is_action_just_pressed("fire1") and helping:
		$CanvasLayer/TextureRect.visible = false
		helping = false

func Update_Ammo():
	ammo_counter.Update_Ammo(0, 0, manual_sprite)
