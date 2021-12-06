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
	draw_list_items()
	$Frame/TreatsCount.text = String(initArgs["source"].get_treats())
	Utils.show_mouse()
	pass # Replace with function body.

func _process(delta):
	if (Input.is_action_just_released("OpenInv") or Input.is_action_just_released("ui_cancel")) and canExit:
		deload()
	canExit = true

func clear_context():
	$Description.text = ""
	$ContextOptionsContainer.clear_context()
	$Frame/INVDisplay.texture = Texture.new()

func deload():
	Global.AudioManager.play_sound(sfx["close"])
	get_tree().paused = false
	Utils.capture_mouse()
	initArgs['source'].call_deferred(initArgs['callback'])
	queue_free()

func draw_context():
	$ContextOptionsContainer.show_context(selected)

func draw_list_items():
	$ListItemContainer.initialize(initArgs["inv"])

func draw_selected_icon():
	if selected != null:
		$Frame/INVDisplay.texture = selected.get_icon(true)
	else:
		$Frame/INVDisplay.texture = Texture.new()

func get_inventory():
	return initArgs["inv"]

func initialize(args = {}):
	print("INV: INitializing")
	initArgs = Utils.check(args, initArgs)

func update_highlighted(i):
	$Frame/INVDisplay.texture = i.get_icon(true)

func update_selection(i, c):
	selected = i
	$Frame/SelectionLabel.text = i.get_name() + ("         x" + String(c) if c > 1 else "")
	$Frame/ItemTreatsLabel.visible = true
	$Frame/ItemTreatsLabel/Label.text = String(selected.get_value()) + " (ea.)"
	$Description.text = i.get_description()
	get_focus_owner().release_focus()
	draw_context()
	draw_selected_icon()
	
