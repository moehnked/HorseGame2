extends Area

var gateRef = null
var links = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_self_to_graph(gate):
	gateRef = gate
	gateRef.add_to_graph(self)
	for i in links:
		i.add_self_to_graph(gate)
	pass

func check_area_link(area):
	if area.has_method("link"):
		link(area)

func check_has_links():
	if links.size() > 0:
		print(self,self.name," has links")
		get_mesh().set_surface_material(0, load("res://Materials/basic_wood_02.tres"))
		return true
	else:
		get_mesh().set_surface_material(0, load("res://Materials/basic_wood.tres"))
		return false

func get_mesh():
	return $fence

func link(other):
	print("linking ", other, " to ", self)
	links.append(other)
	check_has_links()
	if other.gateRef != null:
		gateRef = other.gateRef
		gateRef.call("update_status")
		pass

func search(visited, graph):
	visited.append(self)
	var discovered = 0
	for i in links:
		print(self,":",i)
		if not visited.has(i):
			if graph.links.has(i):
				print("found cycle")
				return 1
			discovered += i.search(visited,graph)
	return discovered

func unlink(other):
	if links.has(other):
		links.erase(other)
		#other.unlink(self)
		pass
	if gateRef != null:
		gateRef.begin_search()
	pass

func _on_Fence_area_entered(area):
	check_area_link(area)
	pass # Replace with function body.


func _on_Fence_area_exited(area):
	if area.has_method("unlink"):
		unlink(area)
	pass # Replace with function body.


func _on_Solid_emit_deconstruct():
	queue_free()
	pass # Replace with function body.
