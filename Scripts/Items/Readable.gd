extends "res://Scripts/Items/Item.gd"

var bookData = {
	"text":[
		"test readable",
		"do not replace"
		],
	"title":"Readable",
}
export(String) var bookSlug = "A1"

var bookUIRef = "res://prefabs/UI/Misc/BookReadBase.tscn"
var isInitialized = false

func _ready():
	$Interactable.connect("emit_prompt", self, "prompt_read")
	$Description.description = bookData["title"]
	itemName = bookData["title"]

func initialize():
	var _bookfile = "res://Data/books/" + bookSlug + ".json"
	var file = File.new()
	if not file.file_exists(_bookfile):
		print("ERROR: no valid data for book")
		return # Error! We don't have a save to load.
	file.open(_bookfile, File.READ)
	var t = file.get_as_text()
	bookData = parse_json(t)
	file.close()
	itemName = bookData["title"]
	print("Book title set to: ", itemName)
	isInitialized = true
	pass

func interact(_controller):
	print("reading")
	#controller = _controller.get_equipment_manager()
	#Utils.reparent(self, Global.world)
	#pickup(controller)
	read_book(_controller)
	pass

func prompt_read(_prompt):
	if not isInitialized:
		initialize()
	_prompt.prompt = "Read - " + bookData["title"]

func read_book(_controller = null):
	var bui = Global.world.instantiate(bookUIRef)
	bui.initialize(bookData, _controller)
	bui.connect("emit_pickup", self, "take_book")

func take_book(_controller, gui):
	gui.disconnect("emit_pickup", self, "take_book")
	controller = _controller.get_equipment_manager()
	Utils.reparent(self, Global.world)
	pickup(controller)
	pass

