#TradingScreen.gd
extends Control

var canExit:bool = false
var callback:String = ""
var customer = null
var displayInventory = []
var selected = null
var source = null
var vendor = null


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.AudioManager.play_sound("res://sounds/ui_open_01.wav")
	pass # Replace with function body.

func initialize(args = {}):
	args = Utils.check(args, {"vendor":null, "customer":null, "callback":"", "source":null})
	$BG.start()
	customer = args.customer
	vendor = args.vendor
	displayInventory = vendor.get_inventory()
	source = args.source
	callback = args.callback
	$tradingscreen/Label.text = "Trading       " + vendor.get_horse_name()
	clear_context()
	Global.InputObserver.subscribe(self)
	var timer = Timer.new()
	timer.connect("timeout",self,"set_can_exit")
	timer.one_shot = true
	add_child(timer) #to process
	timer.start(0.1) #to start
	draw_trading_screen()

func calculate_value(item):
	return item.get_value()

func clear_context():
	draw_description()
	$Context/ItemInfo.text = ""
	$Context/BuyButton.disable()
	$tradingscreen/ItemNameTag.text = ""

func clear_display():
	$Display.texture = null if selected == null else selected.get_icon(true)

func clear_list():
	for i in $InventoryContainer.get_children():
		i.queue_free()

func draw_context(item):
	print("drawing context for ",item)
	print(displayInventory)
	clear_context()
	selected = item
	var c = item.get_context()
	var d = c.get_description()
	draw_description(d.get_description())
	$Context/ItemInfo.text = "Value: " + str(item.get_value())
	$tradingscreen/ItemNameTag.text = selected.get_name()
	$Context/BuyButton.initialize({"item":item, "controller":vendor.get_equipment_manager()})

func draw_description(desc = ""):
	$Context/Description.text = desc

func draw_trading_screen():
	clear_list()
	$tradingscreen.visible = true
	var ref = load("res://prefabs/UI/InventoryListItem.tscn")
	var index = 0
	var u = Utils.uniques(displayInventory)
	print("drawing trading screen")
	print(displayInventory)
	for i in u:
		print("uniques: ",i)
		var li = ref.instance()
		li.initialize(i, self, Utils.count(i, displayInventory))
		li.position .y += 20 * index
		$InventoryContainer.add_child(li)
		index += 1

func parse_input(input):
	if input.engage:
		print("e")
		if canExit:
			Global.InputObserver.unsubscribe(self)
			if source != null:
				if callback != "":
					source.call(callback)
			Global.AudioManager.play_sound("res://sounds/ui_close_01.wav")
			queue_free()

func set_can_exit():
	print("can exit")
	canExit = true

func update_display(item):
	$Display.texture = item.get_icon(true) if item != null else null

func _on_BG_fade_in_complete():
	pass # Replace with function body.

func _on_BuyButton_pressed():
	print(self,"BUY BUTTON PRESSED")
	print(displayInventory)
	if selected != null:
		var money = customer.get_money()
		if money >= selected.get_value():
			if vendor.get_equipment_manager().equipped == selected:
				selected = vendor.get_equipment_manager().unequip()
			money -= selected.get_value()
			customer.set_money(money)
			var a = selected.duplicate(7)
			a.get_context().reset_context()
			a.pickup(customer.get_equipment_manager())
			vendor.get_inventory().erase(selected)
			draw_trading_screen()
			if Utils.contains(selected, vendor.get_inventory()):
				draw_context(Utils.get_item_by_name(selected.get_name(), vendor.get_inventory()))
			else:
				selected.queue_free()
				selected = null
				clear_context()
		
	pass # Replace with function body.
