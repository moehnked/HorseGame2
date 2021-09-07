extends Node

var callback = ""
var initArgs = {}
var listener = null
var speaker = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func initialize(args = {}):
	args = Utils.check(args, {'speaker':null, 'listener':null, 'text':["hellow", "world"], 'call_back':"", "relationship":0, "check_relationship":true})
	initArgs = args
	speaker = args.speaker
	listener = args.listener
	var dialogue = Dialogic.start(args["timelineName"])
	#var dialogue = Dialogic.start("Seamus01")
	add_child(dialogue)
	dialogue.connect('timeline_end', self, 'destroy')
	dialogue.connect("dialogic_signal", self, 'increment_timeline')
	dialogue.connect("event_start", self, 'make_sound')
	make_sound("event_start")
	pass

func destroy(timeline_name):
	print("Destroying dialogue screen")
	print(speaker.name)
	print(listener.name)
	Global.InputObserver.input.engage = false
	speaker.call("exit_dialogue")
	listener.call("exit_dialogue")
	queue_free()

func increment_timeline(value):
	speaker.call("increment_timeline")

func make_sound(eventName, other = {}):
	if not ["endbranch", "call_node", "close_dialog"].has(eventName):
		print("~~ NPCDialogic: ", eventName)
		Global.AudioManager.play_sound(speaker.get_talk_sfx(), speaker.get_speaking_volume())

func trigger_event(eventGroup):
	print("___________ NPC DIALOGUE SCREEN TRIGGERING EVENT ", eventGroup)
	#print("___________ NPC DIALOGUE SCREEN TRIGGERING EVENT ")
	Global.world.trigger_event(eventGroup[0], speaker)
	pass

