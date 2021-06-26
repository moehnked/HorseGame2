extends StaticBody

export(String)var message = ""
signal sign_read(controller)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = message
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	if controller.get_parent() == Global.Player:
		emit_signal("sign_read", controller)
	pass # Replace with function body.
