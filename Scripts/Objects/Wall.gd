extends "res://Scripts/Objects/Destructable.gd"

var completion = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	completion[$Siding] = false
	completion[$Interior] = false
	$CollisionShape.disabled = true
	pass # Replace with function body.

func check_if_complete():
	print("NEOWall: checking completion")
	print(completion)
	for i in completion.values():
		if not i:
			print("incomplete")
			return
	print("complete")
	$wallmesh.queue_free()

func complete_section(n, item):
	n.visible = true
	set_mesh(n, item.get_mat())
	completion[n] = true
	check_if_complete()
	$CollisionShape.disabled = false

func get_interior():
	return $Interior

func get_material_from_node(n):
	return n.get_surface_material(0)

func get_siding():
	return $Siding

func set_mesh(m, mat):
	m.set_surface_material(0, mat)

func set_invisible(n):
	n.visible = false

func set_valid_place(n):
	set_mesh(n, load("res://Materials/Construction/build_valid.tres"))
	n.visible = true

func set_invalid_place(n):
	set_mesh(n, load("res://Materials/Construction/build_invalid.tres"))
	n.visible = true

func _on_UseItemOn_looking_at_with_item(item):
	set_valid_place($Siding)
	pass # Replace with function body.


func _on_UseItemOn_notLookingAt():
	print("NEOWall: no longer looking at")
	set_invisible($Siding)
	pass # Replace with function body.


func _on_UseItemOn_item_use_complete(item):
	complete_section($Siding, item)
	pass # Replace with function body.


func _on_InteriorTrigger_looking_at_with_item(item):
	set_valid_place($Interior)
	pass # Replace with function body.


func _on_InteriorTrigger_notLookingAt():
	set_invisible($Interior)
	pass # Replace with function body.


func _on_InteriorTrigger_item_use_complete(item):
	complete_section($Interior, item)
	pass # Replace with function body.


func _on_UseItemOn_unsuccessful_look_at(item):
	set_invalid_place($Siding)
	pass # Replace with function body.


func _on_InteriorTrigger_unsuccessful_look_at(item):
	set_invalid_place($Interior)
	pass # Replace with function body.
