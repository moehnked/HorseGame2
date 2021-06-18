extends Node2D

var listItemHeight = 20
var listItems = []
var selectedIndex:int = 0
var selectionChange = 1

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
		get_parent().add_child(li)
		li.position.y += 20 * index
		li.set_opacity(1 - max((0.1 * (index - 5)), 0))
		index += 1
		listItems.append(li)

func parse_input(input):
	if input.mouse_up or input.mouse_down and listItems.size() > 10:
		selectionChange = -1 if (input.mouse_up and selectedIndex != 0) else (1 if (input.mouse_down and selectedIndex < listItems.size() - 1) else 0)
		selectedIndex += selectionChange
		selectedIndex = min(max(selectedIndex, 0), listItems.size() -1)
		update_list_scroll()
	

func queue_free():
	Global.InputObserver.unsubscribe(self)
	.queue_free()

func update_list_scroll():
	for i in listItems:
		var idx = listItems.find(i)
		i.position.y -= (20 * selectionChange)
		if idx < selectedIndex:
			i.set_opacity(1 - (0.5 * abs(selectedIndex - idx)))
		elif idx > selectedIndex + 5:
			i.set_opacity(1 - (0.1 * abs(selectedIndex + 5 - idx)))
		#i.set_opacity(1 - ((0.5 if idx < selectedIndex else (0.1 if idx > selectedIndex + 5 else 0)) * abs(selectedIndex - idx)))
