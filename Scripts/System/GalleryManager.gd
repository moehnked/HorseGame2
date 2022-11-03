extends Node

var gallery_file = "user://gallery.json"
var gallery = []

func _ready():
	load_save()
	pass

func acquire_painting(painting):
	gallery.append(painting.filename)
	save_paintings()
	pass

func get_gallery():
	return gallery
	pass

func load_save():
	var file = File.new()
	if file.file_exists(gallery_file):
		file.open(gallery_file, File.READ)
		gallery = parse_json(file.get_line())
	pass

func save_paintings():
	#save active questlog
	var file = File.new()
	file.open(gallery_file, File.WRITE)
	file.store_line(to_json(gallery))
	#save completed quests
