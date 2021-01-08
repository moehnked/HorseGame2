extends Control
var Utils = preload("res://Utils.gd")

var callback = null
var context_buttons = []
var inventory = []
var listItems = []
var selected = null
var sourceRef
var listItemResource = preload("res://prefabs/UI/InventoryListItem.tscn")

func _ready():
	add_to_group("InvScreen")
	Global.AudioManager.play_sound("res://sounds/ui_open_01.wav")

func clear_context():
	draw_description()
	for o in context_buttons:
		o.queue_free()
		context_buttons.erase(o)

func clear_listItems():
	clear_context()
	for o in listItems:
		o.queue_free()
		listItems.erase(o)

func clear_display():
	$Display.texture = null if selected == null else selected.get_icon(true)

func draw_context(item):
	selected = item
	clear_context()
	var c = item.get_context()
	var d = c.get_description()
	draw_description(d.get_description())
	var i = 0
	for b in c.get_buttons():
		print(b)
		var o = b.duplicate()
		o.initialize({"item":item, "controller":sourceRef.get_interaction_controller()})
		$Context.add_child(o)
		o.visible = true
		o.rect_position = $Context/ButtonPoint.rect_position + Vector2((256 * i),0)
		i += 1
		context_buttons.append(o)

func draw_description(desc = ""):
	$Context/Description.text = desc

func draw_list_items():
	clear_listItems()
	var index = 0
	for i in uniques():
		if i.has_method("get_name"):
			var item = listItemResource.instance()
			item.initialize(i, self, Utils.count(i, inventory))
			item.position.x = $ListItemLoader.position.x
			item.position.y = $ListItemLoader.position.y + (item.get_height() * (index))
			add_child(item)
			listItems.append(item)
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
	clear_context()
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

func update_display(item = null):
	#var sprite = load(item.icon)
	$Display.texture = item.get_icon(true) if item != null else null

func _on_Timer_timeout():
	print("inv subscribing")
	subscribe_to()
	pass # Replace with function body.


func _on_ExitButton_button_up():
	terminate()
	pass # Replace with function body.
