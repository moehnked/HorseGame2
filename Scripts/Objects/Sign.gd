extends StaticBody

export(String)var message = ""
export(String)var context = ""
export(String) var groupname = ""
export(bool) var showButtonPrompt = true
signal sign_read(controller)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Interactable.showButtonPrompt = showButtonPrompt
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = message
	pass # Replace with function body.


func get_context():
	return context

func show_context():
	if context != "":
		Global.InteractionPrompt.show_context(get_context())

func _on_Interactable_interaction(controller):
	if controller.get_parent() == Global.Player:
		emit_signal("sign_read", controller)
		show_context()
	pass # Replace with function body.
