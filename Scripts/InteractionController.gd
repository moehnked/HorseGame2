extends Area

onready var promptRef = get_tree().get_root().get_node("World").get_node("InteractionPrompt")

var lookingAt = null
var inventory = []

func clear():
	promptRef.clear()

func parse_input(input):
	if input.engage:
		if lookingAt != null:
			if lookingAt.is_interactable:
				print("interacting with ", lookingAt)
				lookingAt.interact(self)

func read_prompt():
	print("displaying prompt of ",lookingAt)
	promptRef.show_prompt(lookingAt.prompt())
	pass

func _on_InteractionController_area_entered(area):
	if area.has_method("interact"):
		if area.is_interactable:
			print("interaction controller entered ", area.name)
			lookingAt = area
			read_prompt()
	pass # Replace with function body.


func _on_InteractionController_body_entered(body):
	if body.has_method("interact"):
		print("interaction controller entered ", body.name)
		lookingAt = body
		read_prompt()
	pass # Replace with function body.


func _on_InteractionController_body_exited(body):
	if body == lookingAt:
		print("interaction controller exited ", body.name)
		promptRef.clear()
		lookingAt = null
	pass # Replace with function body.


func _on_InteractionController_area_exited(area):
	if area == lookingAt:
		print("interaction controller exited ", area.name)
		promptRef.clear()
		lookingAt = null
	pass # Replace with function body.
