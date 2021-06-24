extends "res://Scripts/System/broadcast_self.gd"

var equipped = null
var equipPoint:Spatial = Spatial.new()
var input:InputMacro = InputMacro.new()
var interactionController = null
var inventory = []

signal emit_equipped(equipment)
signal emit_unequip(equipment)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("broadcast_self", self)
	if get_parent().has_method("get_palm"):
		equipPoint = get_parent().get_palm()
	else:
		equipPoint = get_parent().get_node("HoldingPoint")
	pass # Replace with function body.

func _process(delta):
	if equipped != null:
		equipped.parse_equip({"input":input})

func add_item(item):
	owner.get_inventory().append(item)

func check_if_equip_is_valid(other):
	if equipped != null:
		if equipped.get_name() == other.get_name():
			return false
		else:
			unequip({"caller":self})
	return other != self and other != null and other != get_parent() and other != equipped

func equip(other):
	if check_if_equip_is_valid(other):
		print(other.name, " is valid to equip")
		if !get_inventory().has(other):
			add_item(other)
		equipped = other
		equipped.set_point(equipPoint, self)
		emit_signal("emit_equipped", equipped)
		modify_parent_state(false)
		return true
	return false

func get_equipped():
	return equipped

func get_interaction_manager():
	return interactionController

func get_inventory():
	return inventory

func modify_parent_state(toggle):
	var p = get_parent()
	if p.has_method("enable_casting"):
		if toggle:
			p.enable_casting()
			p.enable_cast_menu()
			p.get_hand().update_hand_sprite("Idle")
		else:
			p.revoke_casting()
			p.revoke_cast_menu()
			p.get_hand().update_hand_sprite(equipped.intendedSprite, false)

func parse_input(_input):
	input = _input

func return_equipped_to_inventory():
	var inv = get_inventory()
	inv.erase(equipped)
	var n = equipped.duplicate(7)
	#n.set_context("Equip")
	inv.append(n)
	equipped.queue_free()
	return n

func set_equip_point(other):
	equipPoint = other

func subscribe_to():
	#print("[eqManager]:Subscribing")
	Global.InputObserver.subscribe(self)

func update_equipped():
	pass

func unequip(args = {}):
	args = Utils.check(args, {"returnToInventory": true,})
	var i = equipped
	equipped.unequip({"caller":self})
	if args.returnToInventory:
		i = return_equipped_to_inventory()
		equipped.queue_free()
	else:
		inventory.erase(equipped)
		equipped.unequip({"caller":self})
	emit_signal("emit_unequip", equipped)
	equipped = null
	modify_parent_state(true)
	return i

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)

func _on_InteractionManager_broadcast_self(controller):
	interactionController = controller
	pass # Replace with function body.

func _on_InteractionManager_emit_looking_at(by, at):
	if equipped != null:
		equipped.recieve_looking_at(by, at)
	pass # Replace with function body.


func _on_InteractionController_broadcast_self(obj):
	interactionController = obj
	pass # Replace with function body.
