extends CanvasLayer

var expression = Expression.new()
@onready var line_edit = $LineEdit
@onready var console = $Container/Console

func _ready():
	line_edit.text_submitted.connect(self._on_text_submitted)
	console.add_text("type Help() to get uhh help!" + "\n")

func _on_text_submitted(command):
	line_edit.text = ""
	
	var error = expression.parse(command)
	if error != OK:
		console.add_text(expression.get_error_text() + "\n")
		return
		
	var result = expression.execute([], self)
	if result != null and not expression.has_execute_failed():
		console.add_text(str(result) + "\n")

func Reload():
	get_tree().reload_current_scene()
