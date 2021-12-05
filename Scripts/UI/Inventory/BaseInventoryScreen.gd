extends Control
var canExit = false
var initArgs = {}
var selected
var sfx = {
	"open":preload("res://Sounds/UI_Open_01.wav"),
	"close":preload("res://Sounds/UI_Close_01.wav")
}



# Called when the node enters the scene tree for the first time.
func _ready():
	print("INV: Ready")
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	Global.AudioManager.play_sound(sfx["open"])
	$ListItemContainer.initialize(initArgs["inv"])
	$Frame/TreatsCount.text = String(initArgs["source"].get_treats())
	Utils.show_mouse()
	pass # Replace with function body.

func _process(delta):
	if (Input.is_action_just_released("OpenInv") or Input.is_action_just_released("ui_cancel")) and canExit:
		deload()
	canExit = true

func deload():
	Global.AudioManager.play_sound(sfx["close"])
	get_tree().paused = false
	Utils.capture_mouse()
	initArgs['source'].call_deferred(initArgs['callback'])
	queue_free()

func initialize(args = {}):
	print("INV: INitializing")
	initArgs = args

func update_highlighted(i):
	$Frame/INVDisplay.texture = i.get_icon(true)

func update_selection(i, c):
	selected = i
	var context = i.get_context()
	$Frame/SelectionLabel.text = i.get_name() + ("               x" + String(c) if c > 1 else "")
	$Description.text = context.get_description().get_description()
