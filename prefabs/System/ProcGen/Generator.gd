extends Spatial

export(Array, Resource) var chunks
export(Dictionary) var specialChunks
export(Dictionary) var uniqueChunks
export(int) var initWorldSize = 40
export(int) var gridsize = 20
export(int) var chunkDist = 3

var chunkMap = {}
var chunksLoaded = {}
var isLoading = false
var playerRef
var prevPoint = Vector2(0,0)
var prevPrevPoint = Vector2(0,0)
var posChain = []
var queueChunks = []
var unQueueChunks = []
var rng
var toggle = true

signal chunk_loaded_at(loc)
signal chunk_unloaded_at(loc)
signal player_gridpos_updated(gridPos)

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Generator = self
	rng = RandomNumberGenerator.new()
	rng.randomize()
	playerRef = Global.Player
	var o = chunks[0].instance()
	gridsize = o.get_size()
	o.queue_free()
	generate()
	process_initial_details()
	var pos = get_player_gridpos()
	procedural_chunk_load(pos)
	posChain.append(pos)
	posChain.append(pos)
	pass # Replace with function body.

func _process(delta):
	var g = get_player_gridpos()
	if !posChain.has(g):
		print("changed! , ", g ,", prev " , posChain[1], ", pp ", posChain[0])
		procedural_chunk_load(g)
		update_visible(g)
		emit_signal("player_gridpos_updated", g)
		update_player_point(g)
	load_chunk_from_queue()
	#unload_chunk_from_unqueue()
	pass


func clear_unque():
	while unQueueChunks.size() > 0:
		unload_chunk_from_unqueue()

func generate():
	var offset = floor(initWorldSize / 2)
	for i in range(initWorldSize):
		for z in range(initWorldSize):
			var c = randi() % chunks.size()
			var ci = Vector2(i - offset,z - offset)
			chunkMap[ci] = c
	pass

func generate_specials(offset):
	for i in specialChunks.keys():
		for n in range(specialChunks[i]):
			var x = rng.randi_range(-offset, offset)
			var y = rng.randi_range(-offset, offset)
			chunkMap[Vector2(x,y)] = i

func generate_uniques():
	for i in uniqueChunks.keys():
		chunkMap[i] = uniqueChunks[i]
	pass
	

func get_player_gridpos():
	var v = (playerRef.global_transform.origin / gridsize)
	return Vector2(floor(v.x), floor(v.z))
	pass

func initial_chunk_load():
	while queueChunks.size() > 0:
		load_chunk_from_queue()
	pass

func load_chunk_at(g):
	if !chunksLoaded.has(g):
		var ref = chunkMap[Vector2(g.x,g.y)]
		var o
		if ref is Resource:
			print("loading resource")
			o = ref.instance()
		else:
			o = chunks[chunkMap[Vector2(g.x,g.y)]].instance()
		call("add_child", o)
		o.global_transform.origin = Vector3(g.x * gridsize, global_transform.origin.y, g.y * gridsize)
		chunksLoaded[g] = o
		emit_signal("chunk_loaded_at", g)

func load_chunk_from_queue():
	if queueChunks.size() > 0 and toggle:
		var g = queueChunks.pop_front()
		load_chunk_at(g)
	pass

func procedural_chunk_load(g):
	var n = chunkDist
	var count = 0
	for i in range(n):
		for z in range(n):
			var v = Vector2(i,z)
			v += g
			v -= Vector2(floor(chunkDist / 2), floor(chunkDist / 2))
			if not queueChunks.has(v):
				queueChunks.append(v)
			count += 1
	pass

func process_initial_details():
	var offset = floor(initWorldSize / 2)
	generate_specials(offset)
	generate_uniques()
	pass

func update_player_point(g):
	posChain.pop_front()
	posChain.append(g)

func unload_chunk_at(i):
	var o = chunksLoaded[i]
	if o.queue_unload():
		chunksLoaded.erase(i)
		emit_signal("chunk_unloaded_at", i)
		o.queue_free()
		unQueueChunks.pop_front()
	pass

func unload_chunk_from_unqueue():
	if unQueueChunks.size() > 0:
		if chunksLoaded.keys().has(unQueueChunks[0]):
			unload_chunk_at(unQueueChunks[0])
		else:
			unQueueChunks.pop_front()

func update_visible(g):
	print("updating visible....", chunksLoaded.keys().size())
	var vs = floor(chunkDist / 2)
	for i in chunksLoaded.keys():
		if unQueueChunks.has(i):
			continue
		if i.x < g.x - vs or i.x > g.x + vs:
			unQueueChunks.append(i)
		if i.y < g.y - vs or i.y > g.y + vs:
			unQueueChunks.append(i)
		pass


func _on_Timer_timeout():
	#print("unload tick")
	unload_chunk_from_unqueue()
	$Timer.start()
	pass # Replace with function body.