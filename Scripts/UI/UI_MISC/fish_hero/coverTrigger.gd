extends Area2D

export(NodePath) var target

func _on_coverTrigger_area_entered(area):
	get_node(target).visible = false
	pass # Replace with function body.


func _on_coverTrigger_area_exited(area):
	get_node(target).visible = true
	pass # Replace with function body.
