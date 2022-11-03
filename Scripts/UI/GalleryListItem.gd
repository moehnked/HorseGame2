extends Control

var painting
var showHoverText = false

signal emit_mouse_enter(painting)
signal emit_mouse_exit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(_painting):
	painting = _painting
	$ColorRect/GridContainer/TextureRect.texture = painting.get_painting_texture()


func _on_TextureRect_mouse_entered():
	emit_signal("emit_mouse_enter", painting)
	$ColorRect.color = Color("4c4a4c")
	pass # Replace with function body.


func _on_TextureRect_mouse_exited():
	emit_signal("emit_mouse_exit")
	$ColorRect.color = Color(0,0,0,0)
	pass # Replace with function body.
