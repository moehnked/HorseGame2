extends Control

onready var listItemResource = preload("res://prefabs/UI/HUDPartyListItem.tscn")

var listItems = {}
var party = {}

func add_party_member(member):
	party[member] = member

func clear_party():
	for i in listItems:
		listItems[i].queue_free()
		listItems.erase(i)
	listItems = {}

func draw_party():
	clear_party()
	var i = 0
	for p in party:
		var l = listItemResource.instance()
		l.rect_position = $ListItemPoint.rect_position
		l.rect_position.y += 60 * i
		l.initialize(i)
		listItems[p] = l
		call_deferred("add_child", l)
		i += 1
	pass

func remove_from_party(member):
	print("HUD: erasing ", member.get_horse_name())
	if(party.has(member)):
		listItems[member].queue_free()
		listItems.erase(member)
		party.erase(member)
	draw_party()

func report(member):
	if(party.has(member)):
		listItems[member].get_node("Bar").rect_size = Vector2((float(member.HP)/float(member.maxhp)) * 166, 15)

func update_display(HP, maxhp = 10):
	$Container/bar.rect_size = Vector2((float(HP)/float(maxhp)) * 275, 25)


