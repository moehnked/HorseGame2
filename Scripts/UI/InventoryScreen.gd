extends Control
#var Utils = preload("res://Utils.gd")

var callback = null
var context_buttons = []
var inventory = []
var initArgs = {}
var listItems = []
var selected = null
var sourceRef
var listItemResource = preload("res://prefabs/UI/InventoryListItem.tscn")

func _ready():
	print(get_path())
	add_to_group("InvScreen")
	Global.AudioManager.play_sound("res://sounds/ui_open_01.wav")
	#Global.Generator.clear_unque()

func _process(delta):
	if Global.Generator != null:
		Global.Generator.unload_chunk_from_unqueue()

func clear_context():
	print("clearing context")
	draw_description()
	for o in context_buttons:
		o.queue_free()
	context_buttons = []

func clear_listItems():
	get_list_screen().clear_list()

func clear_display():
	$Display.texture = null if selected == null else selected.get_icon(true)

func draw_context(item):
	selected = item
	clear_context()
	var c = item.get_context()
	var buttons = c.get_buttons()
	var d = c.get_description()
	draw_description(d.get_description())
	var i = 0
	print("[inv]:drawing context ",buttons)
	for b in buttons:
		print(b.name)
		var o = b.duplicate()
		o.initialize({"item":item, "controller":sourceRef.get_equipment_manager()})
		$Context.add_child(o)
		o.visible = true
		o.rect_position = $Context/ButtonPoint.rect_position + Vector2((256 * i),0)
		i += 1
		context_buttons.append(o)

func draw_description(desc = ""):
	$Context/Description.text = desc

func draw_list_items():
	get_list_screen().draw_list_items(inventory)

func get_list_screen():
	return $ListItemScreen

func initialize(args = {}):
	args = Utils.check(args, {'source':null, 'inv':[], 'callback':null})
	$background.start()
	#print("INITIALIZING INVENTORY SCREEN")
	inventory = args.inv
	sourceRef = args.source
	callback = args.callback
	Utils.show_mouse()
	draw_list_items()
	initArgs = args
	update_treats()
	Global.world.queue_timer(Utils, 0.5, "show_mouse")
	#print(uniques())

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
		if sourceRef.has_method(callback):
			sourceRef.call(callback)
	Global.AudioManager.play_sound("res://sounds/ui_close_01.wav")
	for i in get_children():
		i.call("queue_free")
	queue_free()

func uniques():
	var u = []
	for i in inventory:
		if !Utils.contains(i,u):
			u.append(i)
	return u

func unsubscribe_to():
	#Global.world.get_node("InputObserver").unsubscribe(self)
	Global.InputObserver.unsubscribe(self)

func update_display(item = null):
	$Display.texture = item.get_icon(true) if item != null else null

func update_treats():
	if sourceRef.has_method("get_treats"):
		$Treats/TreatCounter.text = String(sourceRef.get_treats())

func _on_Timer_timeout():
	print("inv subscribing")
	subscribe_to()
	pass # Replace with function body.


func _on_ExitButton_button_up():
	terminate()
	pass # Replace with function body.
