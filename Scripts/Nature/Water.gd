extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_water():
	return true


func _on_Area_body_entered(body):
	if body.has_method("start_swimming"):
		print("water entered...")
		body.start_swimming()
	pass # Replace with function body.

func _on_Area_body_exited(body):
	if body.has_method("stop_swimming"):
		print("water exited...")
		body.stop_swimming()
	pass # Replace with function body.


func _on_Area_area_entered(area):
	if area.has_method("start_swimming"):
		print("water entered...")
		area.start_swimming()
	pass # Replace with function body.


func _on_Area_area_exited(area):
	if area.has_method("stop_swimming"):
		print("water exited...")
		area.stop_swimming()
	pass # Replace with function body.
