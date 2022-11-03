extends Control

onready var lisItemRef = load("res://prefabs/UI/InventoryScreens/GalleryListItem.tscn")
var gallery = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var bigG = get_tree().get_nodes_in_group("Gallery")[0]
	gallery = bigG.get_gallery()
	for p in gallery:
		var o = lisItemRef.instance()
		$HorsesOrnate3/HorsesOrnate3_BG/ScrollContainer/GridContainer.add_child(o)
		o.initialize(load(p).instance())
		o.connect("emit_mouse_enter", self, "update_prompt")
		o.connect("emit_mouse_exit", $HoverContainer, "clear")
	pass # Replace with function body.

func update_prompt(painting):
	$HoverContainer.set_text(painting.get_title())

