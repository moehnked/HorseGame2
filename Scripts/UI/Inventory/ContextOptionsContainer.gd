extends Node2D

var context = Context.context
var selected

var contextResources = {
	context.Discard : preload("res://prefabs/UI/ItemContext_Discard.tscn"),
	context.Equip : preload("res://prefabs/UI/ItemContext_Equip.tscn"),
	context.Unequip: preload("res://prefabs/UI/ItemContext_Unequip.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear_context():
	for c in get_children():
		remove_child(c)
		c.free()

func show_context(i):
	clear_context()
	selected = i
	for co in i.ContextOptions:
		var c = contextResources[co].instance()
		add_child(c)
		c.initialize({"item":i, "controller": get_parent().get_vendor().get_equipment_manager()})
		c.rect_position.y += 23 * i.ContextOptions.find(co)
		var idx = i.ContextOptions.find(co)
		if idx > 0:
			c.set_focus_previous(get_children()[idx - 1].get_path())
			get_child(idx - 1).set_focus_next(c.get_path())
	if get_child_count() > 0:
		get_child(0).grab_focus()
