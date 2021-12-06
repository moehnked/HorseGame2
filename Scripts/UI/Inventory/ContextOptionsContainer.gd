extends Node2D

var context = Context.Context
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
		c.queue_free()

func show_context(i):
	clear_context()
	selected = i
	for co in i.ContextOptions:
		var c = contextResources[co].instance()
		add_child(c)
		c.initialize({"item":i, "controller": get_parent().initArgs["source"].get_equipment_manager()})
		c.rect_position.y += 23 * i.ContextOptions.find(co)
		var idx = i.ContextOptions.find(co)
		if idx > 0:
			c.set_focus_previous(get_children()[idx - 1].get_path())
			get_child(idx - 1).set_focus_next(c.get_path())
	var firs = get_child(0)
	if get_parent().get_focus_owner() != null:
		get_parent().get_focus_owner().release_focus()
	firs.grab_focus()
	print(firs, firs.name)
	
