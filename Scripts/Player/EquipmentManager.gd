extends Node

var equipped = null
var equipPoint:Spatial = Spatial.new()
var input:InputMacro = InputMacro.new()
var interactionController = null
var inventory = []

signal broadcast_self(manager)
signal emit_equipped(equipment)
signal emit_unequip(equipment)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("broadcast_self", self)
	pass # Replace with function body.

func _process(delta):
	if equipped != null:
		equipped.parse_equipped({"input":input})

func check_if_equip_is_valid(other):
	if equipped != null:
		if equipped.get_name() == other.get_name():
			return false
	return other != self and other != null and other != get_parent() and other != equipped

func equip(other):
	if check_if_equip_is_valid(other):
		if !get_inventory().has(other):
			get_inventory().append(other)
		equipped = other
		equipped.set_point(equipPoint, self)
		emit_signal("emit_equipped", equipped)
		modify_parent_state(false)
		return true
	return false

func get_equipped():
	return equipped

func get_inventory():
	return inventory

func modify_parent_state(toggle):
	var p = get_parent()
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
	print("[eqManager]:Subscribing")
	Global.InputObserver.subscribe(self)

func update_equipped():
	pass

func unequip(returnToInventory = true):
	var i = equipped
	equipped.unequip()
	if returnToInventory:
		i = return_equipped_to_inventory()
		equipped.queue_free()
	else:
		inventory.erase(equipped)
		equipped.unequip()
	emit_signal("emit_unequip", equipped)
	equipped = null
	modify_parent_state(true)
	return i

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)

func _on_InteractionManager_broadcast_self(controller):
	pass # Replace with function body.


func _on_Palm_broadcast_self(palm):
	set_equip_point(palm)
	pass # Replace with function body.
