extends Spatial

var canInteract = true
var equipped = null
var inventory = []
var interactables = []
var interactable
var raycast

func _process(delta):
	read_prompt()
	var obj = raycast.get_collider()
	if obj != null:
		if obj.has_method("interact"):
			if obj.isInteractable:
				interactable = obj
				return
	interactable = null

func begin_dialogue(other):
	owner.enter_dialogue(other)

func clear():
	Global.InteractionPrompt.clear()

func disable_interact():
	canInteract = false

func enable_interact():
	canInteract = true

func enter_menu():
	if equipped != null:
		equipped.call("unsubscribe")

func exit_menu():
	if equipped != null:
		equipped.call("subscribe")

func equip(item):
	clear()
	disable_interact()
	equipped = item
	item.parent_transform = owner.get_palm()
	owner.revoke_casting()
	owner.revoke_cast_menu()
	pass

func get_inventory():
	return inventory

func initialize_raycast(_raycast):
	raycast = _raycast

func parse_input(input):
	if input.engage and canInteract:
		if interactable != null:
			if interactable.isInteractable:
				interactable.interact(self)

func read_prompt():
	if canInteract and interactable != null:
		Global.InteractionPrompt.show_prompt(interactable.prompt(), interactable.has_method("is_low"))
	else:
		clear()

func toggle_equip(item):
	print("toggle equip on ", item.get_name())
	if item == equipped:
		return unequip(item)
	else:
		if equipped != null:
			unequip(equipped)
		Utils.remove_item(item, inventory)
		var i = Global.world.instantiate(item.prefabPath)
		var it = i.get_node("Item")
		it.interact(self)
		return it
		

func unequip(item):
	Utils.remove_item(item, inventory)
	var i = item.duplicate()
	inventory.append(i)
	equipped.destroy()
	equipped = null
	return i

func toggle_interactability():
	canInteract = !canInteract
