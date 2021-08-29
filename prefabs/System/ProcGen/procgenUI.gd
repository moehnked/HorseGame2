extends Control

export(NodePath) var generatorPath
export(Resource) var gridspace

var generator
var gridSpaces = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	generator = get_node(generatorPath)
	var gs = generator.chunks_x.size() / 2
	for i in range(generator.chunks_x.size()):
		for n in range(generator.chunks_x.size()):
			var o = gridspace.instance()
			add_child(o)
			o.position.x = i * 5
			o.position.y = n * 5
			gridSpaces[Vector2(i - gs , n - gs)] = o
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$InventoryListItem_button_on.modulate = Color(0,1,0,1) if generator.toggle else Color(1,0,0,1)
	pass


func _on_Generator_player_gridpos_updated(gridPos):
	print("procGenUI: player gridpos updated ", gridPos)
	print("pricGenUI: qs ", generator.queueChunks.size(), " ls ", generator.chunksLoaded.keys().size())
	for i in generator.queueChunks:
		#print(i, " -/- ", gridPos)
		if i == gridPos:
			gridSpaces[i].set_status(2)
		elif gridSpaces[i].status != 3:
			gridSpaces[i].set_status(1)
	pass # Replace with function body.


func _on_Generator_chunk_loaded_at(loc):
	print("ProcGenUI: setting ", loc, " loaded")
	gridSpaces[loc].set_status(3)
	pass # Replace with function body.


func _on_Generator_chunk_unloaded_at(loc):
	gridSpaces[loc].set_status(0)
	pass # Replace with function body.
