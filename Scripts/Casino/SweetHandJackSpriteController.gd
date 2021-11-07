extends Node2D


var cardsDealt = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	pass # Replace with function body.

func call_game_method(method, gameGroup = "Road"):
	print("SHJ ",$AnimationPlayer.current_animation, ": calling ", method, " in ", gameGroup)
	get_tree().call_group(gameGroup, method)

func idle_anim_tick():
	var n = (Global.world.rng.randi() % 1) + 1
	n = "0" + String(n) if n < 10 else String(n)
	set_animation("Idle_" + n)

func initialize():
	$AnimationPlayer.play("default")
	cardsDealt = 0

func play_card_throw_sfx():
	var a = Global.world.rng.randi_range(3,5)
	Global.AudioManager.play_sound("res://Sounds/woosh_0" + String(a) + ".wav")

func play_sound(sfx, db = 0.0):
	Global.AudioManager.play_sound(sfx, db)

func reset_game():
	print("SHJ: resetting game")
	initialize()
	set_animation("Shuffle")

func set_animation(animName):
	$AnimationPlayer.play(animName)

func set_card_visibility(s):
	$Container/CardStack.visible = s

func set_modulation(color):
	$Container.modulate = color

func set_sprite(path):
	$Sprite.texture = load(path) if path is String else path

func start_thinking():
	set_animation("Think_01")

func start_turn():
	set_animation("Turn01")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Deal":
			print("deal card")
			cardsDealt += 1
			get_tree().call_group("Road", "deal_card", cardsDealt, $Container/CardStack.global_position)
			if cardsDealt < 6:
				set_animation("Deal")
			else:
				idle_anim_tick()
	pass # Replace with function body.
