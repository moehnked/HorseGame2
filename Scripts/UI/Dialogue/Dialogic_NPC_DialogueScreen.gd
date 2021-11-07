extends Node

var callback = ""
var canExit = true
var dialogue
var initArgs = {}
var listener = null
var speaker = null

func initialize(args = {}):
	args = Utils.check(args, {'speaker':null, 'listener':null, 'text':["hellow", "world"], 'call_back':"", "relationship":0, "check_relationship":true})
	initArgs = args
	speaker = args.speaker
	listener = args.listener
	if speaker.has_method("enter_dialogue"):
		listener.enter_dialogue(speaker)
	dialogue = Dialogic.start(args["timelineName"])
	add_child(dialogue)
	dialogue.connect('timeline_end', self, 'destroy')
	dialogue.connect("dialogic_signal", self, 'increment_timeline')
	dialogue.connect("event_start", self, 'make_sound')
	make_sound("event_start")
	Global.AudioManager.fade_music(Global.AudioManager.get_current_music_volume() - 10, 0.1)
	pass

func destroy(timeline_name):
	if canExit:
		Global.InputObserver.input.engage = false
		speaker.call("exit_dialogue")
		listener.call("exit_dialogue")
		Global.AudioManager.fade_music(0, 0.1, true)
		queue_free()

func exit_trade():
	canExit = true
	destroy(null)

func has_item(args):
	var count = 1 if args.size() < 3 else int(args[2])
	if Utils.count(args[0], Global.Player.get_inventory()) >= count:
		print("----NPC Has required item ", args[0])
		Dialogic.set_variable(args[1], 1)
	pass

func get_random_text(args):
	var text = Global.RSG.generate_sentance()
	var s = ""
	for i in text:
		s += i + " "
	Dialogic.set_variable(args[0], s)
	pass

func increment_timeline(value):
	speaker.call("increment_timeline")

func make_sound(eventName, other = {}):
	if not ["endbranch", "call_node", "close_dialog", "question", "timeline", "action", "choice", "set_value"].has(eventName):
		print("~~ NPCDialogic: ", eventName)
		Global.AudioManager.play_sound(speaker.get_talk_sfx(), speaker.get_speaking_volume())

func start_sell():
	canExit = false
	var gs = load("res://prefabs/UI/SellScreen.tscn").instance()
	Global.world.add_child(gs)
	gs.initialize( {
			"vendor":speaker, 
			"customer":listener,
			"source":listener,
			"inv":listener.get_inventory(),
			"giftee":speaker,
			"ds":self})

func start_trade():
	canExit = false
	var ts = load("res://prefabs/UI/Dialogue/TradingScreen.tscn").instance()
	Global.world.add_child(ts)
	ts.initialize({"vendor":speaker, "customer":listener, "callback":"exit_trade", "source":self})


func trigger_event(eventGroup):
	print("___________ NPC DIALOGUE SCREEN TRIGGERING EVENT ", eventGroup)
	#print("___________ NPC DIALOGUE SCREEN TRIGGERING EVENT ")
	Global.world.trigger_event(eventGroup[0], speaker)
	pass
