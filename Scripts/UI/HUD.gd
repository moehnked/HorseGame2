extends Control

onready var listItemResource = preload("res://prefabs/UI/HUDPartyListItem.tscn")

var listItems = {}
var partyCount = 0

func add_party_member(member):
	member.add_to_group("inParty")

func check_party_size():
	var n = Global.world.get_tree().get_nodes_in_group("inParty")
	return n.size() < get_parent().get_hat().level

func clear_party():
	for i in listItems:
		listItems[i].queue_free()
		listItems.erase(i)
	listItems = {}

func draw_party():
	clear_party()
	var i = 0
	for p in query_party():
		var l = listItemResource.instance()
		l.rect_position = $ListItemPoint.rect_position
		l.rect_position.y += 60 * i
		l.initialize(i)
		listItems[p] = l
		call_deferred("add_child", l)
		i += 1
	pass

func on_load_complete():
	print("on load complete")
	for n in query_party():
		n.set("trainer", get_parent())
	draw_party()

func query_party():
	var n = get_tree().get_nodes_in_group("inParty")
	return n

func remove_from_party(member):
	print("HUD: erasing ", member.get_horse_name())
	member.remove_from_group("inParty")
	draw_party()

func report(member, hp, maxHP):
	if(member.is_in_group("inParty")):
		#listItems[member].get_node("Bar").rect_size = Vector2((float(member.HP)/float(member.maxhp)) * 166, 15)
		listItems[member].update_display(hp, maxHP)
func save():
	return Utils.serialize_node(self)

func update_display(HP, maxhp = 10):
	$Container/bar.rect_size = Vector2((float(HP)/float(maxhp)) * 275, 25)


