extends Spatial

var callback
var casted = null
var hand
var lookingAt = null
var palm
var raycast
var skipParty = false
var source
var state = CommandType.invalid

enum CommandType {invalid, interactable, attackable}
enum CastSide {left, right}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(args):
	args = Utils.check(args, {'player':null, 'palm':null, 'callback':null, 'hand':null})
	source = args.player
	raycast = source.get_command_raycast()
	if source.get_party().size() > 0 or skipParty:
		raycast.enabled = true
		hand = source.get_hand()
		palm = args.palm
		callback = args.callback
		source.revoke_casting()
		source.revoke_menu_options()
		Global.AudioManager.play_sound("res://Sounds/command_start.wav")
	else:
		cancel()
		Global.InteractionPrompt.show_context("Command Failed: no valid party members")
		conclude()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#update what the raycast is looking at
	update_raycast()
	#check the validity of the target
	#check the input to confirm targetting
	parse_input()
	pass

func animation_return():
	print("animation finished")
	conclude()

func cancel():
	Global.AudioManager.play_sound("res://Sounds/cancel.wav")
	$TTL.start()

func conclude():
	source.conclude_spell("Command")
	source.exit_some_menu()
	raycast.enabled = false
	queue_free()

func get_party():
	return source.get_party()

func give_command():
	hand.play_animation("CommandFin", self)
	Global.AudioManager.play_sound("res://Sounds/command_execute.wav")
	visible = false
	# check cast side
	# if left, give command to first horse only
	if casted == CastSide.left:
		var h = get_party()[0]
		h.recieve_command(lookingAt, 0 if state == CommandType.interactable else 1)
		#h.set_state({"behaviorName":"WalkTo", "target":lookingAt, "callback": "exit_pilot"})
	# if right, give command to all horses

func parse_input():
	casted = CastSide.left if Input.is_action_just_pressed("standard") else (CastSide.right if Input.is_action_just_pressed("special") else null)
	if casted != null:
		if state == CommandType.invalid:
			cancel()
			Global.InteractionPrompt.show_context("no valid target")
		else:
			give_command()
		#conclude()

func update_raycast():
	if raycast.is_colliding():
		lookingAt = raycast.get_collider()
		print(lookingAt.name)
		global_transform.origin = lookingAt.global_transform.origin
		if "isInteractable" in lookingAt:
			state = CommandType.interactable
			$CursorContainer/InteractableCursor.visible = true
			$CursorContainer/AttackableCursor.visible = false
		elif "health" in lookingAt:
			state = CommandType.attackable
			$CursorContainer/InteractableCursor.visible = false
			$CursorContainer/AttackableCursor.visible = true
		else:
			state = CommandType.invalid
			$CursorContainer/InteractableCursor.visible = false
			$CursorContainer/AttackableCursor.visible = false
		
		visible = (state != CommandType.invalid)
