extends "res://Scripts/Horse/Behaviors/HB_Dialogue.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_dialogue(args):
	#var o = load("res://prefabs/UI/Dialogue/DialogueScreen.tscn").instance()
	var o = dialogueScreenRes.instance()
	add_child(o)
	#actor.begin_dialogue(controller)
	talkingToController.begin_dialogue(args.actor)
	#o.initialize({'speaker':args.actor, 'text':RSG.generate_sentance(), 'listener':talkingToController.get_parent(), 'relationship':args.relationship})
	o.initialize({'speaker':args.actor, 'listener':talkingToController.get_parent(), 'text':["hellow", "world"], 'init_options':args.actor.get_options()})
