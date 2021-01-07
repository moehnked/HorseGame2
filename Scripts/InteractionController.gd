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

func duplicate_item(item):
	var i = item.duplicate()
	equipped = i
	Global.world.call("add_child", Utils.instance_item(i))
	i.isEquipped = true
	i.get_context().remove_child(i.get_context().get_equip())
	i.get_context().add("Unequip").visible = false
	i.set_point(owner.get_palm(), self)
	inventory.append(i)

func enable_interact():
	canInteract = true

func equip(item):
	item.set_point(owner.get_palm(), self)
	if not Utils.contains(item, inventory):
		inventory.append(item)
	equipped = item
	clear()
	#disable_interact()
	owner.revoke_casting()
	owner.revoke_cast_menu()
	pass

func get_inventory():
	return inventory

func initialize_raycast(_raycast):
	raycast = _raycast

func parse_input(input):
	update_equipped(input)
	if input.engage and canInteract:
		if interactable != null:
			if interactable.isInteractable:
				interactable.interact(self)

func read_prompt():
	if canInteract and interactable != null:
		Global.InteractionPrompt.show_prompt(interactable.prompt(), interactable.has_method("is_low"))
	else:
		clear()

func disconnect_item(item):
	if item == equipped:
		print("controller: unequipping ", item)
		equipped = null
	if Utils.contains(item, inventory):
		inventory.erase(item)
	enable_interact()
	owner.set_behavior("Normal")

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
		

func update_equipped(input):
	if equipped != null:
		equipped.parse_equip({
			"input": input})

func unequip(item):
	print("controller: unequipping item ", item)
	equipped = null
	Utils.remove_item(item, inventory)
	var i = item.duplicate()
	inventory.append(i)
	i.get_context().remove_child(i.get_context().get_unequip())
	i.get_context().add("Equip").visible = false
	return i

func toggle_interactability():
	canInteract = !canInteract
