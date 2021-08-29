extends "res://Scripts/UI/Dialogue/Talk.gd"


export(Dictionary) var requirements = {}
export(Resource) var conditionOption
export(bool) var takesItems = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func check_items():
	var complete = 0
	for i in requirements.keys():
		var inv = initArgs["ds"].listener.get_inventory()
		if Utils.contains(i, inv):
			var count = Utils.get_all_items_by_name(inv, i)
			if count.size() >= requirements[i]:
				complete += 1
	return complete >= requirements.keys().size()

func remove_required_items():
	for i in requirements.keys():
		var inv = initArgs["ds"].listener.get_inventory()
		var n = requirements[i]
		var num = 0
		for x in range(n):
			Utils.pop_item_by_name(i, inv)
		

func trigger():
	if check_items():
		if takesItems:
			remove_required_items()
		i = lines.size()
		#initArgs["ds"].exit_talk()
		print("YABA DABA DOOOOOOOOOOOO......-----")
		var o = load(conditionOption.resource_path).instance()
		initArgs["ds"].get_container().add_child(o)
		o.initialize(initArgs)
		remove_self_from_current_options(initArgs["ds"].get_options())
		o.select()
		o.trigger()
	else:
		.trigger()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
