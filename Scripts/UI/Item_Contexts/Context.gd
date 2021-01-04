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
