extends Spatial

export(String) var instName = "Platform"

func _ready():
	$AnimationPlayer.play("New Anim")

func set_spec(newName):
	instName = newName


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Learn: " + instName
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	Global.Player.buildList.append(instName)
	queue_free()
	pass # Replace with function body.
