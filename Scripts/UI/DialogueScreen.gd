extends Control

var callback = ""
var canExit:bool = false
var canScrub = false
var destroyOnLower:bool = true
var listener = null
export var speed = 3
var state = "nothing"
var stop_point = Vector2(250,250)
var start_point = Vector2(0,0)
var speaker = null
var typing_text = ""
var text = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	start_point = Vector2($Container.position.x, 610)
	stop_point = Vector2($Container.position.x, OS.get_screen_size().y/2.4)
	pass # Replace with function body.

func _process(delta):
	match(state):
		"lowering":
			lower_window(delta)
		"nothing":
			pass
		"raising":
			raise_window(delta)

func destroy():
	speaker.call("exit_dialogue")
	listener.call("exit_dialogue")
	Global.InputObserver.unsubscribe(self)
	queue_free()

func exit_trade():
	start_timer_exit()

func initialize(args = {}):
	args = Utils.check(args, {'speaker':null, 'listener':null, 'text':["hellow", "world"], 'call_back':"", "relationship":0})
	speaker = args.speaker
	listener = args.listener
	if(speaker.has_method("get_icon")):
		#print(speaker.get_icon())
		set_icon(speaker.get_icon())
	if speaker.has_method("get_horse_name"):
		$Container/Nametag.text = speaker.get_horse_name()
	for i in args.text:
		text += i + " "
	if args.relationship > -1:
		#start dialogue options tree
		init_dialogue_options()
		pass
	else:
		$Timer.start()
	Global.InputObserver.subscribe(self)
	state = "raising"
	callback = args.call_back
	start_timer_exit()
	#$Container/Label.text = text

func init_dialogue_options():
	Utils.show_mouse()
	$Container/Dialogue.text = ""
	$Container/Dialogue.visible = false
	$Container/OptionsContainer.visible = true
	pass

func lower_window(delta):
	if($Container.position.y < start_point.y):
		#$Container.position = $Container.position.linear_interpolate(start_point, delta * speed)
		$Container.position.y += 20
	elif destroyOnLower:
		print("exiting dialogue..........")
		destroy()
	else:
		state = "nothing"

func parse_input(input):
	if input.engage and canExit:
		destroyOnLower = true
		start_exit()

func raise_window(delta):
	if($Container.position.y > stop_point.y):
		$Container.position = $Container.position.linear_interpolate(stop_point, delta * speed)

func set_can_exit():
	canScrub = true
	canExit = true

func set_icon(path):
	var ico = load(path)
	$Container/Icon.texture = ico
	$Container/Icon2.texture = ico

func start_exit():
	print("beginning exit")
	state = "lowering"

func start_timer_exit():
	var timer = Timer.new()
	timer.connect("timeout",self,"set_can_exit")
	timer.one_shot = true
	add_child(timer) #to process
	timer.start(0.1) #to start
	state = "raising"

func start_trade():
	destroyOnLower = false
	canExit = false
	state = "lowering"
	print("starting trade with ", listener, " - ", speaker.get_trainer())
	var ts = load("res://prefabs/UI/Dialogue/TradingScreen.tscn").instance() if speaker.get_trainer() != listener else load("res://prefabs/UI/Dialogue/ExchangeScreen.tscn").instance()
	Global.world.add_child(ts)
	ts.initialize({"vendor":speaker, "customer":listener, "callback":"exit_trade", "source":self})
	Global.InputObserver.unsubscribe(self)

func write_text():
	#print(typing_text)
	$Container/Dialogue.text = typing_text
	if(typing_text.length() < text.length()):
		typing_text += text[min(typing_text.length(), text.length() - 1)]

func _on_Timer_timeout():
	#print("dialogue timer")
	canScrub = true
	write_text()
	if(typing_text.length() < text.length()):
		$Timer.start()
	pass # Replace with function body.


func _on_Talk_emit_selected():
	$Container/OptionsContainer.visible = false
	$Container/Dialogue.visible = true
	$Timer.start()
	pass # Replace with function body.


func _on_Exit_emit_selected():
	destroyOnLower = true
	start_exit()
	pass # Replace with function body.

func _on_Trade_emit_selected():
	start_trade()
	pass # Replace with function body.
