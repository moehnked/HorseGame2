extends Node2D

var canSelect = false
var initArgs = {}
var resPath = ""
var selected:bool = false

export var optionText = "OPTION"
export var readImmediately = true

signal emit_selected()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = optionText
	deselect()
	pass # Replace with function body.

func clear_previous_selection():
	var ds = initArgs.ds
	if ds != null:
		var so = ds.get_selected()
		if so != null:
			so.deselect()
	pass

func deselect():
	$Sprite.modulate = Color("#75000000")
	$Label.modulate = Color("#676767")
	selected = false
	pass

func get_height():
	return $Label.get_global_rect().size

func initialize(args = {}):
	args = Utils.check(args, {"ds": null})
	initArgs = args
	canSelect = true
	Global.InputObserver.subscribe(self)

func parse_input(input):
	if input.standard and selected and canSelect:
		emit_signal("emit_selected")
		canSelect = false

func queue_free():
	#print("freeing dialogue option " , name)
	Global.InputObserver.unsubscribe(self)
	.queue_free()

func select():
	#print("DO: selected ", name)
	$Sprite.modulate = Color("#9f818181")
	$Label.modulate = Color("#ffffff")
	selected = true
	initArgs.ds.set_selected(self)
	pass

func set_resource_path(resp):
	resPath = resp

func _on_Label_mouse_entered():
	select()
	pass # Replace with function body.


func _on_Label_mouse_exited():
	deselect()
	pass # Replace with function body.
