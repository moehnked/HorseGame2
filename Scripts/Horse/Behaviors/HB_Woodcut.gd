extends "res://Scripts/Horse/Behaviors/HorseBehavior.gd"

var hasStartedCutting = false
var hasStartedSearch
var isSearching = true
var hasFoundTree = false
var targetTree = null

onready var treeSearcher = preload("res://prefabs/Misc/TreeSearch.tscn")

func initialize(args = {}):
	args = .initialize(args)
	print("initializing woodcut state")
	if args.keys().has("hasFoundTree"):
		hasFoundTree = args["hasFoundTree"]
		print("Has Found Tree!!!!!!!!!!!!!!!!")
		isSearching = false
	else:
		hasStartedCutting = false
		hasStartedSearch = false
		isSearching = true
		hasFoundTree = false
		targetTree = null

func cut_tree():
	print("======== tree cut down!=========")
	for i in get_children():
		remove_child(i)
		i.queue_free()
	targetTree.fell()
	initialize()

func locate_tree(other):
	print("FOUND TREE ", other.name)
	targetTree = other

func run(delta):
	if not hasStartedSearch:
		start_searching_for_tree()
	if targetTree != null:
		if Utils.check_dist(actor, targetTree, 2):
			hasFoundTree = false
			isSearching = true
		if isSearching:
			actor.enter_walk_to({"target": targetTree, "callback":"set_state", "kargs":{"behaviorName":stateName, "hasFoundTree": true}})
		pass
	if hasFoundTree and not hasStartedCutting:
		start_cutting()
	pass

func start_cutting():
	print("starting to cut wood")
	actor.get_animation_controller().play_animation("Idle")
	var timer = Timer.new()
	timer.connect("timeout", self, "cut_tree")
	add_child(timer)
	timer.start(5)
	hasStartedCutting = true

func start_searching_for_tree():
	var ts = treeSearcher.instance()	
	Global.world.call("add_child", ts)
	ts.global_transform.origin = actor.global_transform.origin
	ts.initialize({"caller": self})
	hasStartedSearch = true
	actor.get_animation_controller().play_animation("Idle")

func tree_not_found():
	print("Could not locate tree")
	actor.enter_idle()
