extends Control

const Utils = preload("res://Utils.gd")

var callback = ""
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
	raise_window(delta)
	if Input.is_action_just_released("engage"):
		start_exit()
	#write_text()

func initialize(args = {}):
	args = Utils.check(args, {'speaker':null, 'listener':null, 'text':["hellow", "world"], 'call_back':""})
	speaker = args.speaker
	listener = args.listener
	if(speaker.has_method("get_icon")):
		#print(speaker.get_icon())
		set_icon(speaker.get_icon())
	for i in args.text:
		text += i + " "
	$Timer.start()
	state = "raising"
	callback = args.call_back
	#$Container/Label.text = text

func lower_window(delta):
	print("lowering - ", $Container.position.y, " - ",  (start_point.y))
	if($Container.position.y < start_point.y):
		#$Container.position = $Container.position.linear_interpolate(start_point, delta * speed)
		$Container.position.y += 20
	else:
		print("exiting dialogue..........")
		speaker.call("exit_dialogue")
		listener.call("exit_dialogue")
		queue_free()

func raise_window(delta):
	if($Container.position.y > stop_point.y):
		$Container.position = $Container.position.linear_interpolate(stop_point, delta * speed)

func set_icon(path):
	var ico = load(path)
	$Container/Icon.texture = ico
	$Container/Icon2.texture = ico

func start_exit():
	state = "lowering"

func write_text():
	#print(typing_text)
	$Container/Label.text = typing_text
	if(typing_text.length() < text.length()):
		typing_text += text[min(typing_text.length(), text.length() - 1)]



func _on_Timer_timeout():
	#print("dialogue timer")
	write_text()
	if(typing_text.length() < text.length()):
		$Timer.start()
	pass # Replace with function body.
