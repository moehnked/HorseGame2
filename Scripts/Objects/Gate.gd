#Gate.gd
extends "res://Scripts/Objects/Fence.gd"

var cycle = []

var isCompleted:bool = false
var isOpen:bool = false
var midPointObject = null

func _ready():
	gateRef = self
	update_solid()

func begin_search():
	var visited = []
	var discovered = 0
	visited.append(self)
	for i in links:
		discovered += i.search(visited, self)
	return {"hasCycle":discovered > 0, "visited":visited}

func check_has_links():
	if links.size() > 0:
		print(self,self.name," has links")
		set_surfaces(load("res://Materials/basic_wood_02.tres"))
		return true
	else:
		set_surfaces(load("res://Materials/basic_wood.tres"))
		return false

func complete():
	var grc = Global.GCR
	grc.register(self)
	var midpoint = grc.calculate_midpoint(cycle)
	midPointObject = Global.world.instantiate("res://prefabs/Misc/TestPoint.tscn",midpoint)
	isCompleted = true
	print("CONTAINS COMPLETED CYCLE")

func filter_cycle(cycle):
	for i in cycle:
		for sub in i.links:
			var sub_cycle_links = 0
			for j in sub.links:
				if cycle.has(j) and j != i:
					sub_cycle_links += 1
			if sub_cycle_links == 0:
				cycle.erase(sub)
	return cycle

func get_mesh():
	return $gate

func get_midpoint():
	return midPointObject

func link(other):
	.link(other)

func queue_complete():
	var timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout",self,"complete") 
	add_child(timer) #to process
	timer.start(0.1)
	

func set_surfaces(mat):
	var count = get_mesh().get_surface_material_count()
	var i = 0
	while i < count:
		get_mesh().set_surface_material(i, mat)
		i += 1

func uncomplete():
	isCompleted = false
	cycle = []
	print("NOT COMPLETED")

func update_solid():
	var mat = load("res://Materials/invisible.tres") if isOpen else load("res://Materials/basic_wood.tres")
	$Solid/CollisionShape2.disabled = isOpen
	for i in [1,2,3,4,5]:
		get_mesh().set_surface_material(i, mat)
	pass
	
func update_status():
	var ret = begin_search()
	if ret.hasCycle:
		cycle = filter_cycle(ret.visited)
		print("current cylce:")
		for i in cycle:
			print(i.name)
		queue_complete()
	else:
		uncomplete()

func _on_Gate_area_entered(area):
	check_area_link(area)
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	var status = "Close" if isOpen else "Open"
	_prompt.prompt = status
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	isOpen = !isOpen
	print("open") if isOpen else print("close")
	update_solid()
	pass # Replace with function body.
