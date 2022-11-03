#extends Spatial
extends "res://Scripts/Persistent.gd"

export var title:String = ""
export var description:String = ""
export var date:String = ""

var sfx = preload("res://Sounds/jrpgUI/Purchase.wav")

func _ready():
	$Interactable.connect("interaction", self, "painting_acquired")

func get_painting_texture():
	var t = $MeshInstance.get_surface_material(0).albedo_texture 
	return load("res://icon.png") if t == null else t

func get_title():
	return description if title == "" else title

func painting_acquired(controller = null):
	Global.AudioManager.play_sound(sfx, -5)
	print("Painting acquired")
	$Interactable.queue_free()
	#$Interactable.set_interactable(false, true)
	Global.world.get_tree().call_group("Gallery", "acquire_painting", self)
	pass

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = title + " (" + date + ") - " + description 
	pass # Replace with function body.
