extends Node2D

var initArgs = {}
var selected:bool = false
var canSelect = false
export var optionText = "OPTION"
export var readImmediately = true

signal emit_selected()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.InputObserver.subscribe(self)
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
	$Label.modulate = Color("#75000000")
	selected = false
	pass

func initialize(args = {}):
	args = Utils.check(args, {"ds": null})
	initArgs = args
	canSelect = true

func parse_input(input):
	if input.standard and selected and canSelect:
		emit_signal("emit_selected")
		canSelect = false

func queue_free():
	#print("freeing dialogue option")
	Global.InputObserver.unsubscribe(self)
	.queue_free()

func select():
	#print("selected ", name)
	$Sprite.modulate = Color("#9f818181")
	$Label.modulate = Color("#ffffff")
	selected = true
	initArgs.ds.set_selected(self)
	pass

func _on_Label_mouse_entered():
	select()
	pass # Replace with function body.


func _on_Label_mouse_exited():
	deselect()
	pass # Replace with function body.
