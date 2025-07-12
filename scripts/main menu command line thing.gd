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
	get_tree().change_scene_to_file(lv[level])

func Reload():
	get_tree().reload_current_scene()
