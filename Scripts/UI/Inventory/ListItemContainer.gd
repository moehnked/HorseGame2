extends Node2D

var listItemRef = preload("res://prefabs/UI/InventoryScreens/ListItemBase.tscn")

func compare_selected(inv):
	var i = get_parent().selected
	if i != null:
		if Utils.contains(i, inv):
			get_parent().update_selection(Utils.get_item_by_name(i.get_name(), inv), Utils.count(i, get_parent().get_inventory()))
		else:
			get_parent().clear_context()
			get_parent().selected = null
			get_child(0).grab_focus()
	get_parent().draw_selected_icon()
	pass

func initialize(inventory):
	for c in get_children():
		c.queue_free()
	var inv = Utils.uniques(inventory)
	for i in inv:
		var li = listItemRef.instance()
		var idx = inv.find(i)
		add_child(li)
		li.rect_position.y += 32 * idx
		li.set_item(i)
		li.set_count(Utils.count(i, inventory))
		li.connect("emit_focus_entered", owner, "update_highlighted" )
		li.connect("emit_selected", owner, "update_selection" )
		print("INV: ListItemContainer: added item ", li.is_inside_tree())
		if idx > 0:
			li.set_focus_previous(get_children()[idx - 1].get_path())
			get_children()[idx - 1].set_focus_next(li.get_path())
#	if get_child_count() > 0:
#		get_child(0).grab_focus()
	compare_selected(inv)


