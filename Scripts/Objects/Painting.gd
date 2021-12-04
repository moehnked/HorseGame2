extends Spatial

export var title:String = ""
export var description:String = ""
export var date:String = ""

var sfx = preload("res://Sounds/jrpgUI/Purchase.wav")

func _ready():
	$Interactable.connect("interaction", self, "painting_acquired")

func painting_acquired(controller = null):
	Global.AudioManager.play_sound(sfx, -5)
	print("Painting acquired")
	$Interactable.queue_free()
	Global.world.get_tree().call_group("Gallery", "acquire_painting", self)
	pass

func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = title + " (" + date + ") - " + description 
	pass # Replace with function body.
