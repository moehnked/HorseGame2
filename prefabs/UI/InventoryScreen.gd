extends Control
var Utils = preload("res://Utils.gd")

var callback = null
var inventory = []
var sourceRef
var listItemResource = preload("res://prefabs/UI/InventoryListItem.tscn")

func _ready():
	Global.AudioManager.play_sound("res://sounds/ui_open_01.wav")

func clear_display():
	$Display.texture = null

func draw_list_items():
	var index = 0
	for i in uniques():
		if i.has_method("get_name"):
			var item = listItemResource.instance()
			item.initialize(i, self, Utils.count(i, inventory))
			item.position.x = $ListItemLoader.position.x
			item.position.y = $ListItemLoader.position.y + (item.get_height() * (index))
			add_child(item)
			index += 1

func initialize(args):
	args = Utils.check(args, {'source':null, 'inv':[], 'callback':null})
	print("INITIALIZING INVENTORY SCREEN")
	inventory = args.inv
	sourceRef = args.source
	callback = args.callback
	Utils.show_mouse()
	draw_list_items()
	print(uniques())

func parse_input(input):
	if input.tab:
		terminate()
	pass

func subscribe_to():
	Global.InputObserver.subscribe(self)

func terminate():
	print("inventory screen terminating...")
	unsubscribe_to()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(callback)
	if callback != null:
		sourceRef.call(callback)
	Global.AudioManager.play_sound("res://sounds/ui_close_01.wav")
	queue_free()

func uniques():
	var u = []
	for i in inventory:
		if !Utils.contains(i,u):
			u.append(i)
	return u

func unsubscribe_to():
	Global.world.get_node("InputObserver").unsubscribe(self)

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
