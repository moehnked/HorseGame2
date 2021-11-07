extends "res://Scripts/Horse/Behaviors/HB_Dialogue.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_dialogue(args):
	if talkingToController.has_method("begin_dialogue"):
	#var o = load("res://prefabs/UI/Dialogue/DialogueScreen.tscn").instance()
		var o = dialogueScreenRes.instance()
		add_child(o)
		#actor.begin_dialogue(controller)
		talkingToController.begin_dialogue(args.actor)
		var dialogueName = actor.get_dialogue_point() if actor.has_method("get_dialogue_point") else "emptyDialogue"
		o.initialize({'speaker':args.actor, 'listener':talkingToController.get_parent(), 'text':["hellow", "world"], 'timelineName':dialogueName})