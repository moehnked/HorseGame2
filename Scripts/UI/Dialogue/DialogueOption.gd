extends Node2D

var selected:bool = false
export var optionText = "OPTION"

signal emit_selected()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.InputObserver.subscribe(self)
	$Label.text = optionText
	deselect()
	pass # Replace with function body.

func deselect():
	$Sprite.modulate = Color("#75000000")
	$Label.modulate = Color("#75000000")
	selected = false
	pass

func parse_input(input):
	if input.standard and selected:
		emit_signal("emit_selected")

func queue_free():
	print("freeing dialogue option")
	Global.InputObserver.unsubscribe(self)
	.queue_free()

func select():
	print("selected ", name)
	$Sprite.modulate = Color("#9f818181")
	$Label.modulate = Color("#ffffff")
	selected = true
	pass

func _on_Label_mouse_entered():
	select()
	pass # Replace with function body.


func _on_Label_mouse_exited():
	deselect()
	pass # Replace with function body.
