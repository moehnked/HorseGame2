extends "res://Scripts/UI/DialogueScreen.gd"

#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func destroy():
	if exitPlayerDialogueOnExit:
		listener.call("exit_dialogue")
		if speaker.has_method("exit_dialogue"):
			speaker.call("exit_dialogue")
	#print("patches exiting dialogue")
	#print(listener.name)
	#print(listener.isRunning)
	#print("- ", listener.is_focused())
	Global.InputObserver.unsubscribe(self)
	queue_free()

func exit_talk():
	#print("EXITING TALK")
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
	#print("out of lines")
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

func get_options_offset(index):
	var offset = 0
	#print("PDS: getting options offset at ", index)
	for i in range(index):
		var cs = $Container/OptionsContainer.get_children()
		var i_cs_height = cs[i].get_height().y
		print(cs, " - ", i_cs_height)
		offset += max(i_cs_height/ 2, 0)
	#print("PDS: offset = ", index, " - ", offset)
	return offset

func initialize(args = {}):
	.initialize(args)
	setup_options(initArgs["init_options"])
	init_dialogue_options()
	#init_icons(args["speaker"])

func init_icons(speaker):
	if speaker.has_method("get_icon"):
		var ico = speaker.call("get_icon")
		$Container/Icon.texture = ico
		$Container/Icon2.texture = ico
	pass

func setup_options(ops = []):
	#print("PDS: ----------------setting up options")
	stop_point.y = OS.get_screen_size().y/2.4 - (30 * max(ops.size() - 3, 0))
	var index = 0
	var prev = null
	for i in ops:
		#print("PDS: i already instanced: ", Utils.check_options_contains(i, $Container/OptionsContainer.get_children()))
		if not Utils.check_options_contains(i, $Container/OptionsContainer.get_children()):
			var o = load(i.resource_path).instance()
			$Container/OptionsContainer.add_child(o)
			o.set_resource_path(i.resource_path)
			#var k = Node2D.new()
			o.position.y += get_options_offset(index)
			#if prev != null:
			#	o.position.y += max(prev.get_height().y - 63, 0) / 2
			#prev = o
			#print("PDS: ", o.get_height().y)
			o.initialize({"ds": self})
		index += 1

func start_talking():
	var randomSFX
	#randomSFX = "res://Sounds/guide_0" + String(Global.world.rng.randi_range(1,4)) + ".wav"
	randomSFX = speaker.get_talk_sfx()
	if "lines" in selectedOption:
		if selectedOption.i == 0 or selectedOption.sfxOnEachLine:
			Global.AudioManager.play_sound(randomSFX, speaker.get_speaking_volume() if speaker.has_method("get_speaking_volume") else 0)
	.start_talking()
