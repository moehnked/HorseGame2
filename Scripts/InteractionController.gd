extends Area

onready var promptRef = get_tree().get_root().get_node("World").get_node("InteractionPrompt")

var canInteract = true
var inventory = []
var lookingAt = null


func clear():
	promptRef.clear()

func disable_interact():
	canInteract = false

func enable_interact():
	canInteract = true

func parse_input(input):
	if input.engage and canInteract:
		if lookingAt != null:
			if lookingAt.is_interactable:
				print("interacting with ", lookingAt)
				lookingAt.interact(self)

func read_prompt():
	if canInteract:
		print("displaying prompt of ",lookingAt)
		promptRef.show_prompt(lookingAt.prompt())
		pass

func toggle_interactability():
	canInteract = !canInteract

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
