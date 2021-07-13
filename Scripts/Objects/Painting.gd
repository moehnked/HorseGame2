extends Spatial

export var title:String = ""
export var description:String = ""
export var date:String = ""

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = title + " (" + date + ") - " + description 
	pass # Replace with function body.
