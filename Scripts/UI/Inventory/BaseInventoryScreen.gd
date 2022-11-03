extends Control
var canExit = false
var emptySprite = preload("res://Sprites/misc/empty_small.png")
var initArgs = {}
var selected = null
var highlighted = null
var sfx = {
	"open":preload("res://Sounds/UI_Open_01.wav"),
	"close":preload("res://Sounds/UI_Close_01.wav")
}
var prevFocusOwner



# Called when the node enters the scene tree for the first time.
func _ready():
	print("INV: Ready")
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	Global.AudioManager.play_sound(sfx["open"])
	draw_list_items()
	Utils.show_mouse(true)
	pass # Replace with function body.

func _process(delta):
	Utils.show_mouse()
	if (Input.is_action_just_released("OpenInv") or Input.is_action_just_released("ui_cancel")) and canExit:
		deload()
	canExit = true

func clear_context():
	$Description.text = ""
	$ContextOptionsContainer.clear_context()
	$Frame/INVDisplay.texture = emptySprite
	$Frame/SelectionLabel.text = ""
	$Frame/ItemTreatsLabel.visible = false
	highlighted = null

func deload():
	Global.AudioManager.play_sound(sfx["close"])
	get_tree().paused = false
	Utils.capture_mouse()
	get_source().call_deferred(initArgs['callback'])
	queue_free()

func draw_context():
	$ContextOptionsContainer.show_context(selected)

func draw_list_items():
	$Frame/ListItemContainer.initialize(initArgs["inv"])

func draw_selected_icon(skipHighlighted = false):
	#print("drawing_sel_icon")
	if highlighted != null and not skipHighlighted:
		$Frame/INVDisplay.texture = highlighted.get_icon(true)
	elif selected != null:
		$Frame/INVDisplay.texture = selected.get_icon(true)
	else:
		$Frame/INVDisplay.texture = emptySprite

func focus_debug(cont):
	print("focus changed: ", cont, ", ", (cont.name if cont != null else ""))

func get_inventory():
	return initArgs["inv"]

func get_item_value():
	return selected.get_value()

func get_source():
	return initArgs['source']

func get_vendor():
	return get_source()

func initialize(args = {}):
	print("INV: INitializing")
	initArgs = Utils.check(args, initArgs)

func pause():
	pause_mode = Node.PAUSE_MODE_STOP
	visible = false

func play_error():
	Global.AudioManager.play_sound(load("res://Sounds/Audio/error_00" + String(Global.world.rng.randi_range(1, 5)) +".ogg"), -10)

func unpause():
	pause_mode = Node.PAUSE_MODE_PROCESS
	visible = true

func update_highlighted(i):
	#print(i.get_name()," highlighted")
	highlighted = i
	$Frame/INVDisplay.texture = i.get_icon(true)

func update_selection(i, c):
	#print("selected: ", i.get_name())
	selected = i
	print(i.get_controller())
	var iname = i.get_name()
	if iname.length() > 15:
		iname = iname.left(15) + "..."
	$Frame/SelectionLabel.text = iname + ("         x" + String(c) if c > 1 else "")
	$Frame/ItemTreatsLabel.visible = true
	$Frame/ItemTreatsLabel/Label.text = String(get_item_value()) + " (ea.)"
	$Description.text = i.get_description()
	draw_selected_icon(true)
	draw_context()
