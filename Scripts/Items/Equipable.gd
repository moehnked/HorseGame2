#Equipable.gd
extends "res://Scripts/Items/Item.gd"

#const horseRef = preload("res://Scripts/Horse/Horse.gd")

var canUnequip = true
var equipState:String = "Equip"
var input = InputMacro.new()
var isEquipped:bool = false
var parentedTo:Spatial = Spatial.new()
#var hasReparented

export var canInteractWhileEquipped:bool = false
export var equipSoundPath:String = "res://Sounds/unequip_01.wav"
export var unequipSoundPath:String = "res://Sounds/equipment_03.wav"
export var intendedSprite = "Holding"

signal emit_held()
signal emit_use()
signal emit_equipped(item)

func _ready():
	#Utils.reparent(self, Global.world)
	pass

func _process(delta):
	if isEquipped:
		set_interactable(false, true)
		#print("equiped")
		update_position_to_parent()
		if controller.get_parent().has_method("get_x_rotation"):
			update_rotation_to_parent()
		if input.left_mouse_pressed or input.left_mouse_pressed:
			emit_signal("emit_held")
		if input.standard or input.special:
			emit_signal("emit_use")
		pass

func apply_behavior(HB):
	if HB != null:
		var p = controller.get_parent()
		if p != null:
			print("p is ", p.name)
			#if p is horseRef:
			if p is Horse:
				print("applying to horse")
				p.call("add_behavior", HB)
				p.call("set_state", Utils.check(HB.initialArgs, {"behaviorName":HB.stateName}))

func clear_context():
	get_context().clear_equipment_context()

func equip(_controller):
	print("equipable:",self.name,":equip - ", isEquipped)
	controller = _controller
	if _controller.has_method("get_equipment_manager"):
		controller = _controller.get_equipment_manager()
	if controller.equip(self):
		print("successfully equipped")
		set_sleeping(false)
		Utils.reparent(self, Global.world)
		toggle_collisions(false)
		$Interactable.isInteractable = false
		isEquipped = true
		set_context(Context.context.Unequip)
		Global.AudioManager.play_sound(equipSoundPath)
		apply_behavior(get_behavior())
		update_depth_test(self)
		emit_signal("emit_equipped", self)
		return true
	return false

func interact(_controller):
	print("equipable::interact")
	if not equip(_controller):
		pickup(controller)

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input

func recieve_looking_at(by, obj):
	pass

func set_context(_equipState):
	#var i = ContextOptions.find(_equipState)
	ContextOptions.erase(Context.context.Equip)
	ContextOptions.erase(Context.context.Unequip)
	ContextOptions.append(_equipState)

func set_point(object, _controller):
	#print("setting point to ", object)
	controller = _controller
	parentedTo = object

func toggle_collisions(enabl = true):
	for i in get_children():
		if i is CollisionShape:
			i.disabled = not enabl
	

func unequip(args = {}):
	if canUnequip:
		args = Utils.check(args, {"caller":null})
		set_context(Context.context.Equip)
		isEquipped = false
		parentedTo = Spatial.new()
		controller = null
		toggle_collisions(true)
		Global.AudioManager.play_sound(unequipSoundPath)
		$Interactable.set_interactable(true)
		update_depth_test(self, false)
	

func update_depth_test(node, val = true):
	print("UPDATE depth test ", node," ", get_child_count())
	if node is MeshInstance:
		var smCount = node.get_surface_material_count()
		if smCount > 0:
			print("found ", smCount, "materials")
			var m = 0
			while m < smCount:
				var mat = node.get_surface_material(m)
				print("Material ",m, " - ", mat)
				if mat is SpatialMaterial:
					print("setting depth test to false")
					mat.flags_no_depth_test = val
				m += 1
	var num = node.get_child_count()
	if num > 0:
		for n in node.get_children():
			update_depth_test(n, val)

func update_position_to_parent():
	global_transform.origin = parentedTo.global_transform.origin

func update_rotation_to_parent():
	rotation.z = -controller.get_parent().get_x_rotation()
	rotation.y = controller.get_parent().rotation.y
	rotation.x = controller.get_parent().get_head().rotation.z
	rotation.y += deg2rad(-80)
