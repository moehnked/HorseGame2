extends "res://Scripts/System/broadcast_self.gd"

var equipped = null
var equipPoint:Spatial = Spatial.new()
var input:InputMacro = InputMacro.new()
var interactionController = null

export(Array) var inventory

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
	inventory.append(item)
	print("added item to horse, player's inv:")
	print(self, " - ", Global.Player.get_equipment_manager(), " - " , Global.Player.get_inventory())

func check_if_equip_is_valid(other):
	if equipped != null:
		if equipped.get_name() == other.get_name():
			return false
		else:
			unequip({"caller":self})
	return other != self and other != null and other != get_parent() and other != equipped

func equip(other):
	if check_if_equip_is_valid(other):
		print("EqM: ", get_parent().name,get_parent(), " - ", other.name, " is valid to equip")
		print("EqM: ", Global.Player.name,Global.Player, " - ", Global.Player.get_equipment_manager())
		print("EqM: ", get_inventory(), " p: ", Global.Player.get_inventory())
		print("EqM: ", self, " eqm: ", get_parent().get_equipment_manager())
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
			#p.get_hand().update_hand_sprite(equipped.intendedSprite, false, 1.2)
			p.get_hand().idle_hand()
			p.get_hand().set_animation_playback(false, 1.2)
			p.get_hand().apply_texture(equipped.intendedSprite)
	print("EQUIP -~~*~ ", p.get_node("Head/Palm").transform.origin)

func parse_input(_input):
	input = _input
	if Input.is_action_just_released("Sheathe"):
		if equipped != null:
			unequip()

func return_equipped_to_inventory():
	print("FPS: EQManager: ", equipped.get_name(), " - ", equipped.owner, " - ", equipped.get_parent().name )
	Utils.reparent(equipped, Global.world)
	#equipped.owner.remove_child(equipped)
	equipped.get_parent().remove_child(equipped)
	return equipped

func set_equip_point(other):
	equipPoint = other

func save():
	var save_dict = inst2dict(self)
	return save_dict

func subscribe_to():
	Global.InputObserver.subscribe(self)

func update_equipped():
	pass

func unequip(args = {}):
	args = Utils.check(args, {"returnToInventory": true,})
	var i = equipped
	if i.canUnequip:
		equipped.unequip({"caller":self})
		if args.returnToInventory:
			i = return_equipped_to_inventory()
		else:
			inventory.erase(equipped)
			#equipped.unequip({"caller":self})
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
