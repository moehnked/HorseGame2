extends Spatial

var canInteract = true
var canReadPrompt:bool = true
var equipped = null
var inventory = []
var interactables = []
var interactable
var raycast

func _process(delta):
	read_prompt()
	var obj = raycast.get_collider()
	if obj != null and obj != self and obj != equipped:
		passdown_looking_at(obj)
		if obj.has_method("interact"):
			if obj.isInteractable:
				if obj.has_method("recieve_looking_at"):
					obj.recieve_looking_at(self)
				interactable = obj
				return
	interactable = null
	enable_can_read()

func begin_dialogue(other):
	owner.enter_dialogue(other)

func clear():
	Global.InteractionPrompt.clear()

func compare_item_with_equipped(item):
	if item.name == equipped.name and item != equipped:
		item.set_context(equipped.get_equip_state())

func disable_interact():
	canInteract = false

func disconnect_item(item):
	if item == equipped:
		print(name,": unequipping ", item.get_parent().name)
		unequip(item, false)
	if Utils.contains(item, inventory):
		Utils.remove_item(item, inventory)
		#inventory.erase(item)
	enable_interact()
	owner.set_behavior("Normal")

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

func enable_can_read():
	canReadPrompt = true

func equip(item):
	if equipped != null and equipped != item:
		print("interactionController: unequipping old item: ",equipped.get_parent().name)
		equipped.get_context().get_unequip().unequip()
	item.set_point(owner.get_palm(), self)
	if not inventory.find(item) >= 0:
		inventory.append(item)
	equipped = item
	for i in Utils.get_all_items_by_name(get_inventory(), item.name):
		compare_item_with_equipped(i)
	clear()
	#disable_interact()
	owner.revoke_casting()
	owner.revoke_cast_menu()
	owner.get_hand().update_hand_sprite(item.intendedSprite)
	pass

func get_equipped():
	return equipped

func get_inventory():
	return inventory

func get_looking_at():
	return interactable

func initialize_raycast(_raycast):
	raycast = _raycast

func parse_input(input):
	update_equipped(input)
	if input.engage and canInteract:
		if interactable != null:
			if interactable.isInteractable:
				interactable.interact(self)
				Global.world.queue_timer(self, 5.0, "enable_can_read")
				canReadPrompt = false
				clear()

func passdown_looking_at(obj):
	if equipped != null:
		if equipped.has_method("recieve_looking_at"):
			equipped.recieve_looking_at(obj)

func read_prompt():
	if canInteract and interactable != null and canReadPrompt:
		Global.InteractionPrompt.show_prompt(interactable.prompt(), interactable.has_method("is_low"))
	else:
		clear()

func set_hand_playback(b = true):
	owner.get_hand().set_animation_playback(b)

func update_equipped(input):
	if equipped != null:
		equipped.parse_equip({
			"input": input})

func unequip(item, returnItemToInventory = true):
	print(name,": unequipping item ", item.get_parent().name)
	equipped = null
	enable_interact()
	if returnItemToInventory:
		Utils.remove_item(item, inventory)
		var i = item.duplicate()
		inventory.append(i)
		return i
	owner.get_hand().update_hand_sprite("Idle")
	set_hand_playback()
	return item

func toggle_interactability():
	canInteract = !canInteract
