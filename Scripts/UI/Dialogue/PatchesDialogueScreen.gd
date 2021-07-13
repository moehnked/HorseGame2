extends "res://Scripts/UI/DialogueScreen.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy():
	if exitPlayerDialogueOnExit:
		listener.call("exit_dialogue")
	print("patches exiting dialogue")
	print(listener.name)
	print(listener.isRunning)
	print("- ", listener.is_focused())
	Global.InputObserver.unsubscribe(self)
	queue_free()

func start_talking():
	var randomSFX = "res://Sounds/guide_0" + String(Global.world.rng.randi_range(1,4)) + ".wav"
	if "lines" in selectedOption:
		if selectedOption.i == 0:
			Global.AudioManager.play_sound(randomSFX)
	.start_talking()

func exit_talk():
	print("EXITING TALK")
	var readNext = selectedOption.readImmediately
	if "lines" in selectedOption:
		if selectedOption.i < selectedOption.lines.size():
			.exit_talk()
			selectedOption.trigger()
			print("still more lines")
		else:
			exit_talk_helper(readNext)
	else:
		exit_talk_helper(readNext)

func exit_talk_helper(readNext = false):
	print("out of lines")
	var o = selectedOption
	$Container/OptionsContainer.clear_options()
	if initArgs.speaker.has_method("get_options"):
		initArgs["init_options"] = initArgs.speaker.call("get_options")
	.exit_talk()
	if o.has_method("close"):
		o.call("close")
	if readNext:
		selectedOption = $Container/OptionsContainer.get_children()[0]
		selectedOption.call("trigger")

func initialize(args = {}):
	#print("INITIALIZING PATCHES")
	.initialize(args)
	setup_options(initArgs["init_options"])
	init_dialogue_options()
	#$Container/Label.text = text

func setup_options(ops = []):
	var index = 0
	for i in ops:
		var o = load(i.resource_path).instance()
		$Container/OptionsContainer.add_child(o)
		#var k = Node2D.new()
		o.position.y += index * 30
		o.initialize({"ds": self})
		index += 1
