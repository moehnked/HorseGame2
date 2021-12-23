extends ScrollContainer

var listItemRef = preload("res://prefabs/UI/InventoryScreens/ListItemBase.tscn")

func add_child(node, n=false):
	$VBoxContainer.add_child(node, n)

func compare_selected(inv):
	#print("scrollContainer: comparing selected")
	var i = get_parent().selected
	if i != null:
		if Utils.contains(i, inv):
			get_parent().update_selection(Utils.get_item_by_name(i.get_name(), inv), Utils.count(i, get_parent().get_inventory()))
		else:
			focus_item_list()
	else:
		focus_item_list()
		get_parent().draw_selected_icon()
	pass

func initialize(inventory):
	for c in get_children():
		c.free()
	var inv = Utils.uniques(inventory)
	for i in inv:
		var li = listItemRef.instance()
		var idx = inv.find(i)
		add_child(li)
		#li.rect_position.y += 12 * idx
		li.set_item(i)
		li.set_count(Utils.count(i, inventory))
		li.connect("emit_focus_entered", get_parent(), "update_highlighted" )
		li.connect("emit_selected", get_parent(), "update_selection" )
		print("INV: ListItemContainer: added item ", li.is_inside_tree())
		if idx > 0:
			li.set_focus_previous(get_children()[idx - 1].get_path())
			get_children()[idx - 1].set_focus_next(li.get_path())
#	if get_child_count() > 0:
#		get_child(0).grab_focus()
	compare_selected(inv)

func get_child(idx):
	return $VBoxContainer.get_child(idx)

func get_children():
	return $VBoxContainer.get_children()

func get_child_count():
	return $VBoxContainer.get_child_count()

func get_parent():
	return owner

func focus_item_list():
	get_parent().clear_context()
	get_parent().selected = null
	if get_child_count() > 0:
		get_child(0).grab_focus()
