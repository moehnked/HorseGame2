extends "res://Scripts/Items/Equipable.gd"

export(bool) var isRigid = true

var isBeingPlaced = false
var ogMaterial
var placedOBJ = null
var placedCursor = null
var raycast
var hasBeenPlaced = false

func _process(delta):
	if isEquipped:
		toggle_collisions(false)
		if placedCursor == null:
			init_place()
			#initialize_placer()
		else:
			#placedOBJ.global_transform.origin = raycast.get_collision_point() + Vector3(0, placedOBJ.scale.y / 2, 0)
			if raycast.is_colliding():
				placedCursor.global_transform.origin = raycast.get_collision_point()
				placedCursor.global_transform.basis = Basis(raycast.get_collision_normal() * -1)
			#global_transform.looking_at(raycast.get_collision_point(),Vector3.UP)
			#placedOBJ.set_interactable(false, true)
			if input.standard:
				#print("Placeable: ", controller, ", ",placedOBJ.controller, ", ",placedOBJ.isEquipped, ", ",self, ", ",placedOBJ)
				#get_context().get_discard().discard()
				hasBeenPlaced = true
				controller.unequip({"returnToInventory": false})
				toggle_collisions(true)
				global_transform.origin = placedCursor.global_transform.origin
				rotation_degrees = Vector3.ZERO
				#placedOBJ.queue_free()
				placedCursor.queue_free()
	else:
		toggle_collisions(true)

func init_place():
#	placedOBJ = get_mesh().duplicate(8)
#	Global.world.place(placedOBJ)
#	placedOBJ.global_transform = get_mesh().global_transform
#	placedOBJ.set_surface_material(0, load("res://Shaders/cool.tres"))
	raycast = controller.get_parent().get_solid_raycast()
#	placedOBJ.global_transform.origin = raycast.get_collision_point() + Vector3(0, placedOBJ.scale.y / 2, 0)
#	placedOBJ.rotation_degrees = Vector3.ZERO
	placedCursor = Global.world.instantiate("res://prefabs/Effects/Sigil01.tscn", raycast.get_collision_point())

func initialize_placer():
	placedOBJ = duplicate(8)
	placedOBJ.set_mode(MODE_STATIC)
	Utils.instance_item(placedOBJ)
	placedOBJ.isEquipped = false
	placedOBJ.toggle_collisions(false)
	placedOBJ.rotation_degrees = Vector3.ZERO
	placedOBJ.set_interactable(false, true)
	raycast = controller.get_parent().get_solid_raycast()
	placedOBJ.isBeingPlaced = true
	placedOBJ.set_sleeping(true)
	placedOBJ.update_mesh()
	placedCursor = Global.world.instantiate("res://prefabs/Effects/Sigil01.tscn", raycast.get_collision_point())

func update_mesh():
	for i in get_children():
		if i is MeshInstance:
			var mat = load("res://Shaders/cool.tres") if isBeingPlaced else ogMaterial
			i.set_surface_material(0, mat)

func unequip(args = {}):
	if placedCursor != null:
		placedCursor.queue_free()
	if placedOBJ != null:
		placedOBJ.queue_free()
	.unequip(args)
