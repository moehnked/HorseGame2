extends Control

var a = 0.0
export var fade_rate = 0.04
var state = State.fadein
var playerRef
var rootRef
var selected
var options = ["Punch", "Lasso", "Build", "Charm"]
var option_objects = []
var leftHand
var rightHand
var sfx = [
	"res://sounds/quick_equip.wav",
	"res://sounds/quick_equip_exit.wav",
	"res://sounds/quick_equip_select_01.wav",
	"res://sounds/quick_equip_select_02.wav"
]


enum State {fadein, test, fadeout}

func play_sound(index):
	var sound = load(sfx[index])
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()

func _process(delta):
	match state:
		State.fadein:
			fadein_step()
		State.fadeout:
			fadeout_step()

func initialize(player, root, left, right):
	playerRef = player
	rootRef = root
	leftHand = left
	rightHand = right
	$container/LeftHand.texture_normal =  load("res://Sprites/UI/QE_" + leftHand + ".png")
	$container/RightHand.texture_normal = load("res://Sprites/UI/QE_" + rightHand + ".png")
	play_sound(0)
	
func subscribe_to():
	rootRef.get_node("InputObserver").subscribe(self)

func unsubscribe_to():
	rootRef.get_node("InputObserver").unsubscribe(self)

func parse_input(input):
	if input.mouse_down:
		rootRef.play_sound(sfx[1])
		clear_options()
		$container.visible = false
		state = State.fadeout
		unsubscribe_to()
		playerRef.update_spells(leftHand, rightHand)

func fadein_step():
	a += fade_rate
	$ColorRect.color += Color(0,0,0,fade_rate)
	if (a > 0.6):
		print("done")
		state = State.test
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$container.visible = true
		subscribe_to()
		

func fadeout_step():
	a -= fade_rate
	$ColorRect.color -= Color(0,0,0,fade_rate)
	if (a < 0.0):
		print("done")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		playerRef.exit_update_hands_menu()
		queue_free()

func select_spell(spell, side):
	play_sound(3)
	print(spell, " selected")
	selected.texture_normal =  load("res://Sprites/UI/QE_" + spell + ".png")
	match side:
		"left":
			leftHand = spell
		"right":
			rightHand = spell

func ready_options(side):
	play_sound(2)
	for i in range(0, options.size()):
		var option = load("res://prefabs/UI/HandOption.tscn").instance()
		option.rect_position.x = (selected.rect_position.x - 128) if (i == 0 or i == 6 or i == 7) else ((selected.rect_position.x) if (i == 1 or i == 5) else (selected.rect_position.x + 128))
		option.rect_position.y = (selected.rect_position.y - 128) if (i == 0 or i == 1 or i == 2) else ((selected.rect_position.y) if (i == 3 or i == 7) else (selected.rect_position.y + 128))
		option.initialize(options[i], self, side)
		option_objects.append(option)
		call_deferred("add_child", option)

func clear_options():
	if(option_objects.size() != 0):
		for i in range(0, options.size()):
			option_objects[i].queue_free()

func _on_LeftHand_button_up():
	print("clicked left")
	selected = $container/LeftHand
	ready_options("left")


func _on_RightHand_pressed():
	print("clicked right")
	selected = $container/RightHand
	ready_options("right")
