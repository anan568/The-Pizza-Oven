extends Control

@export var pizza_maker: Node2D
@onready var pizzas = [$"Pizza Counter/Pizza2/Sprite2D", $"Pizza Counter/Pizza1/Sprite2D", $"Pizza Counter/Pizza/Sprite2D"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for i in range(pizza_maker.pizza_left):
		pizzas[i].frame = 0
		
	for i in range(pizza_maker.pizza_left, 3):
		pizzas[i].frame = 1
