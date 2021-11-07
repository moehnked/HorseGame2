extends Node2D
class_name PlayingCard

enum Suite {Heart, Club, Diamond, Spade}
enum State {Dealing, Normal}

var isFlipped = true
var isSelectable = false
var selected = false
var suite = Suite.Heart
var value = 1
var cardID = 1

var state = State.Normal
var dealtoPos = Vector2.ZERO
var dealtoSize = Vector2.ONE

signal emit_clicked(card)
signal emit_mouse_hover()
signal emit_mouse_exit()

func _to_string():
	return String(cardID) + ": " + String(value) + " of " + Suite.keys()[suite]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_back()
	pass # Replace with function body.

func _process(delta):
	if not isSelectable:
		selected = false
	if Input.is_action_just_released("standard") and selected:
		emit_signal("emit_clicked", self)
	match state:
		State.Dealing:
			position = position.linear_interpolate(dealtoPos, 0.1)
			scale = scale.linear_interpolate(dealtoSize, 0.1)
			rotation_degrees = lerp(rotation_degrees, 0, 0.1)
			if position.distance_to(dealtoPos) < 0.1 and scale.distance_to(dealtoSize) < 0.01:
				state = State.Normal

func flip():
	isFlipped = !isFlipped
	$AnimationPlayer.play("flip")

func get_suite_shorthand():
	return Suite.keys()[suite].left(1)

func play_animation(anim):
	$AnimationPlayer.play(anim)

func set_back():
	$CardContainer/Card2.visible = isFlipped
	$CardContainer/Container.visible = !isFlipped

func set_color(c):
	$CardContainer/Container/Label.modulate = c
	$CardContainer/Container/Label2.modulate = c

func set_card(val = 1, s = Suite.Heart):
	cardID = val
	value = (val % 13) + 1
	set_card_text(value)
	self.suite = cardID % 4
	print("setting card value: ID: ", val, " Value: ", value, " Suite: ", suite)
	match suite:
		Suite.Heart:
			$CardContainer/Frame.texture = load("res://Sprites/Casino/Cards/Hearts.png")
			set_color(Color(1,0,0,1))
			pass
		Suite.Diamond:
			$CardContainer/Frame.texture = load("res://Sprites/Casino/Cards/Diamonds.png")
			set_color(Color(1,0,0,1))
			pass
		Suite.Club:
			$CardContainer/Frame.texture = load("res://Sprites/Casino/Cards/Clubs.png")
			set_color(Color(0,0,0,1))
			pass
		Suite.Spade:
			set_color(Color(0,0,0,1))
			$CardContainer/Frame.texture = load("res://Sprites/Casino/Cards/Spades.png")
			pass

func set_card_text(val):
	match val:
		1:
			update_card_label("A")
		11:
			update_card_label("J")
		12:
			update_card_label("Q")
		13:
			update_card_label("K")
		_:
			update_card_label(String(val))
	

func set_deal_to(pos, sca, rot):
	dealtoPos = pos
	dealtoSize = sca
	rotation_degrees = rot
	state = State.Dealing

func update_card_label(text):
	$CardContainer/Container/Label.text = text
	$CardContainer/Container/Label2.text = text

func _on_Panel_mouse_entered():
	if isSelectable:
		selected = true
		$AnimationPlayer.play("hover")
		emit_signal("emit_mouse_hover")
		Global.AudioManager.play_sound("res://Sounds/Audio/maximize_008.ogg", -5)
	pass # Replace with function body.


func _on_Panel_mouse_exited():
	if isSelectable:
		selected = false
		$CardContainer.modulate = Color(1,1,1,1)
		$AnimationPlayer.play("default")
		emit_signal("emit_mouse_exit")
	pass # Replace with function body.
