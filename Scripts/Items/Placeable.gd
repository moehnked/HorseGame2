extends "res://Scripts/Items/Equipable.gd"

export(Resource) var coolMat
export(bool) var isRigid = true

var cursorRef = preload("res://prefabs/Effects/Sigil01.tscn")
var isBeingPlaced = false
var hasBeenPlaced = false
var ogMaterial
var placedOBJ = null
var placedCursor = null
var raycast


func _process(delta):
	if isEquipped:
		toggle_collisions(false)
		if placedCursor == null:
			init_place()
		else:
			if raycast.is_colliding():
				placedCursor.global_transform.origin = raycast.get_collision_point()
				placedCursor.global_transform.basis = Basis(raycast.get_collision_normal() * -1)
			if input.standard:
				hasBeenPlaced = true
				controller.unequip({"returnToInventory": false})
				toggle_collisions(true)
				global_transform.origin = placedCursor.global_transform.origin
				rotation_degrees = Vector3.ZERO
				placedCursor.queue_free()
	else:
		toggle_collisions(true)

func init_place():
	raycast = controller.get_parent().get_solid_raycast()
	placedCursor = Global.world.instantiate(cursorRef.instance(), raycast.get_collision_point())

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
	placedCursor = Global.world.instantiate(cursorRef.instance(), raycast.get_collision_point())

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
