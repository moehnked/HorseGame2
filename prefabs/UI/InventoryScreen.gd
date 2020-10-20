extends Control

var _callback = null
var inventory = []
var rootRef
var sourceRef
var listItemResource = preload("res://prefabs/UI/InventoryListItem.tscn")

func clear_display():
	$Display.texture = null

func draw_list_items():
	var index = 0
	for i in inventory:
		if i.has_method("get_name"):
			print(i.get_name())
			var item = listItemResource.instance()
			item.initialize(i, self)
			item.position.x = $ListItemLoader.position.x
			item.position.y = $ListItemLoader.position.y + (item.get_height() * (index))
			add_child(item)
			index += 1

func initialize(source, root, inv = [], callback = null):
	inventory = inv
	rootRef = root
	sourceRef = source
	_callback = callback
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	draw_list_items()
	pass

func parse_input(input):
	if input.tab:
		terminate()
	pass

func terminate():
	print("inventory screen terminating...")
	unsubscribe_to()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(_callback)
	if _callback != null:
		sourceRef.call(_callback)
	queue_free()

func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)

func update_display(item):
	var sprite = load(item.icon)
	$Display.texture = sprite

func _on_Timer_timeout():
	print("inv subscribing")
	subscribe_to()
	pass # Replace with function body.


func _on_ExitButton_button_up():
	terminate()
	pass # Replace with function body.
