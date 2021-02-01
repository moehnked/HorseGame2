extends Node

func add(context):
	var c = load("res://prefabs/UI/ItemContext_" + context + ".tscn").instance()
	add_child(c)
	return c

func get_description():
	var d = get_node("Description")
	return d if d != null else load("res://prefabs/UI/ItemContext_Description.tscn").instance()

func get_equip():
	var e = get_node("Equip")
	return e

func get_discard():
	var d = get_node("Discard")
	return d

func get_buttons():
	var buttons = get_children()
	buttons.erase(get_description())
	return buttons

func get_unequip():
	var u = get_node("Unequip")
	return u

func remove_all_children():
	for o in get_children():
		remove_child(o)
		o.queue_free()

func reset_context():
	var desc = get_description().duplicate()
	remove_all_children()
	add_child(desc)
	add("Discard").visible = false
	if get_parent().has_method("equip"):
		add("Equip").visible = false
	

func clear_equipment_context():
	for o in get_children():
		if o.has_method("is_equip") or o.has_method("is_unequip"):
			remove_child(o)
			o.queue_free()
