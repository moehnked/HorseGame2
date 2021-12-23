extends Control

var a = 0.0
export var fade_rate = 0.04
var state = State.fadein

var rightIsBeingSelected = false
var leftIsBeingSelected = false

var source
var rootRef
var selected
var optionSelection = 0
var options = ["Null"]
var option_objects = []
var leftHand
var rightHand


export(Array, AudioStream) var sfx
export(Dictionary) var spellIcons

enum State {fadein, test, fadeout}

func _ready():
	print("UPDATE HANDS: READY")

func play_sound(index):
	Global.AudioManager.play_sound(sfx[index])

func _process(delta):
	match state:
		State.fadein:
			fadein_step()
		State.fadeout:
			fadeout_step()

func initialize(_source, left, right):
	source = _source
	options = source.get_spell_list()
	leftHand = left
	rightHand = right
	$container/LeftHand.texture_normal =  spellIcons[leftHand]
	$container/RightHand.texture_normal = spellIcons[rightHand]
	play_sound(0)
	Global.AudioManager.fade_music(Global.AudioManager.get_current_music_volume() - 10, 0.1)
	print("UH: ", source, ", ", source.name, " - ", source.get_parent().name)
	
func subscribe_to():
	Global.InputObserver.subscribe(self)

func unsubscribe_to():
	Global.InputObserver.unsubscribe(self)

func parse_input(input):
	if input.mouse_down:
		Global.AudioManager.play_sound(sfx[1])
		clear_options()
		$container.visible = false
		state = State.fadeout
		unsubscribe_to()
		Global.AudioManager.fade_music(0, 0.1)
		source.update_spells(leftHand, rightHand)
	if Input.is_action_just_released("PadLeft") and not leftIsBeingSelected:
		leftIsBeingSelected = true
		select_left_hand()
	if Input.is_action_just_released("PadRight") and not rightIsBeingSelected:
		rightIsBeingSelected = true
		select_right_hand()
	if Input.is_action_just_released("ui_right") and option_objects.size() > 0:
		optionSelection = (optionSelection + 1) % option_objects.size()
		option_objects[optionSelection].engage()
	if Input.is_action_just_released("ui_left") and option_objects.size() > 0:
		optionSelection = (optionSelection - 1) % option_objects.size()
		option_objects[optionSelection].engage()
		

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
		source.exit_update_hands_menu()
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
	clear_options()
	Global.world.get_tree().call_group("UI_Event", "trigger", self)
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
		for i in option_objects:
			i.queue_free()

func select_left_hand():
	print("clicked left")
	selected = $container/LeftHand
	ready_options("left")


func select_right_hand():
	print("clicked right")
	selected = $container/RightHand
	ready_options("right")
