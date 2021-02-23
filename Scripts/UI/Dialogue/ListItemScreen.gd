extends Node2D

var listItemHeight = 20
var listItems = []
var selectedIndex:int = 0

func _ready():
	Global.InputObserver.subscribe(self)
	pass

func calc_index_diff(i):
	var dif = selectedIndex - i
	if dif > 1:
		return 0.0
	if dif == 1:
		return 0.5
	if dif == -8:
		return 0.5
	if dif < -8:
		return 0.0

func clear_list():
	for i in listItems:
		i.queue_free()
	listItems = []

func draw_list_items(displayInventory):
	clear_list()
	var ref = load("res://prefabs/UI/InventoryListItem.tscn")
	var index = 0
	var u = Utils.uniques(displayInventory)
	for i in u:
		var li = ref.instance()
		add_child(li)
		li.initialize(i, get_parent(), Utils.count(i, displayInventory))
		add_child(li)
		li.position.y += 20 * index
		index += 1
		
		listItems.append(li)

func parse_input(input):
	if input.mouse_up:
		selectedIndex += 1
	if input.mouse_down:
		selectedIndex -= 1
	#update_list_scroll()

func queue_free():
	Global.InputObserver.unsubscribe(self)
	.queue_free()

func update_list_opacity():
	for i in listItems:
		var j = listItems.find(i)
		if j < selectedIndex - 1:
			pass
		elif j > selectedIndex + 8:
			pass
		pass

func update_list_scroll():
	for i in listItems:
		i.position.y = position.y + ((listItems.find(i) - selectedIndex) * 20)
