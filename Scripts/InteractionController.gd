extends Area

onready var promptRef = get_tree().get_root().get_node("World").get_node("InteractionPrompt")

var canInteract = true
var inventory = []
var interactables = []
var equipped = null

func begin_dialogue(other):
	owner.enter_dialogue(other)

func clear():
	promptRef.clear()

func disable_interact():
	canInteract = false

func enable_interact():
	canInteract = true

func equip(item):
	clear()
	disable_interact()
	equipped = item
	item.parent_transform = owner.get_palm()
	owner.revoke_casting()
	owner.revoke_menu_options()
	pass

func get_inventory():
	return inventory

func parse_input(input):
	if input.engage and canInteract:
		if interactables.size() > 0:
			if interactables.back().isInteractable:
				interactables.back().interact(self)
				read_prompt()

func read_prompt():
	if canInteract and interactables.size() > 0:
		promptRef.show_prompt(interactables.back().prompt(), interactables.back().has_method("is_low"))
		pass
	else:
		clear()

func toggle_interactability():
	canInteract = !canInteract

func _on_InteractionController_area_entered(area):
	if area.has_method("interact"):
		if area.isInteractable:
			interactables.append(area)
			read_prompt()
	pass # Replace with function body.


func _on_InteractionController_body_entered(body):
	if body.has_method("interact"):
		print("interaction controller entered ", body.name)
		interactables.append(body)
		read_prompt()
	pass # Replace with function body.


func _on_InteractionController_body_exited(body):
	if interactables.has(body):
		interactables.erase(body)
		read_prompt()
	pass # Replace with function body.


func _on_InteractionController_area_exited(area):
	if interactables.has(area):
		interactables.erase(area)
		read_prompt()
	pass # Replace with function body.
