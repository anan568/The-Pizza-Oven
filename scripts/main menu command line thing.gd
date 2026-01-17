extends CanvasLayer

var expression = Expression.new()
@onready var line_edit = $Control/LineEdit

var lv = ["res://scenes/levels/better_main_menu.tscn",
"res://scenes/levels/lv 0, pt corp.tscn"]

func _on_line_edit_text_submitted(new_text):
	line_edit.text = ""
	
	var error = expression.parse(new_text)
	if error != OK:
		print_debug(expression.get_error_text())
		return
		
	var result = expression.execute([], self)
	if result != null and not expression.has_execute_failed():
		print_debug(str(result))

func Load(level: int):
	#FILE CHANGED BY FEINKY!
	#get_tree().change_scene_to_file(lv[level])
	print("Manual load disabled. Use the button instead.")

func Reload():
	get_tree().reload_current_scene()


func _on_button_pressed() -> void:
	# Example: Always load the first level in the list
	var level_to_load = 1 
	
	# Check if the level index actually exists in your 'lv' array
	if level_to_load < lv.size():
		get_tree().change_scene_to_file(lv[level_to_load])
	else:
		print("Error: That level index doesn't exist!") # Replace with function body.
