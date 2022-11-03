#InteractableObject.gd
extends Area

var beingLookedAtBy = null
var isHolding = false
var isInteractable:bool = true
var timer = Timer.new()

export(AudioStream) var interactSound = preload("res://Sounds/equipment_02.wav")
export var isHoldToInteract:bool = false
export var playSoundOnInteract:bool = true
export var prompt = ""
export(bool) var showButtonPrompt = true

signal interaction(controller)
signal holding(controller)
signal release()
signal emit_prompt(_prompt)
signal emit_looking_at(_lookedAtBy)

func _input(ev):
	if beingLookedAtBy != null and isInteractable:
		if (Input.is_key_pressed(KEY_E) or Input.is_action_pressed("engage")) and isHoldToInteract:
			emit_signal("holding", beingLookedAtBy)
			beingLookedAtBy.clear()
			isHolding = true
		if Input.is_action_just_released("engage") and isInteractable:
			beingLookedAtBy.clear()
			isHolding = false
			if isHoldToInteract:
				emit_signal("release")
			else:
				interact(beingLookedAtBy)

func _process(delta):
	if beingLookedAtBy != null and isInteractable and not isHolding:
		if beingLookedAtBy.canInteract and beingLookedAtBy.get_looking_at() == self:
			Global.InteractionPrompt.show_prompt(prompt(), false, showButtonPrompt)
		else:
			beingLookedAtBy.clear()
			beingLookedAtBy = null
			pass

func check_if_being_looked_at(compare):
	if compare == self:
		return true
	return false

func recieve_looking_at(controller):
	beingLookedAtBy = controller
	emit_signal("emit_looking_at", beingLookedAtBy)

func interact(controller):
	if isInteractable:
		if playSoundOnInteract:
			play_sound(interactSound)
		set_interactable(false)
		#Global.world.queue_timer(self, 1.0, "interaction_cooldown")
		timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.connect("timeout", self, "interaction_cooldown")
		start_interaction_cooldown()
		emit_signal("interaction", controller)
		isInteractable = false
	pass

func play_sound(path):
	print("Intractable: playing sound")
	Global.AudioManager.play_sound(path)

func prompt():
	emit_signal("emit_prompt", self)
	return prompt

func queue_free():
	Utils.report_node_deletion(self)
	.queue_free()

func save():
	var properties = {
		"timer": timer.time_left,
	}
	return Utils.serialize_node(self, properties)

func set(param, val):
	match param:
		"beingLookedAtBy":
			beingLookedAtBy = Global.Player.get_interaction_controller() if (val != null) else null
		"timer":
			timer = Timer.new()
			if val != 0:
				start_interaction_cooldown(val)
		_:
			.set(param, val)

func set_interactable(state = true, matchPromptState = false, disableCooldown = false):
	isInteractable = state
	showButtonPrompt = state if matchPromptState else showButtonPrompt
	if disableCooldown:
		timer.stop()
		timer.free()
		timer = Timer.new()

func start_interaction_cooldown(time = 1.0):
	timer.start(time)

func interaction_cooldown():
	print("Interactable: cooldown complete")
	set_interactable(true)
	pass # Replace with function body.


func on_body_enter(body):
	if body.has_method("get_interaction_controller"):
		var ic = body.get_interaction_controller()
		ic.set_inside_interactable(self)
	pass # Replace with function body.


func on_body_exit(body):
	if body.has_method("get_interaction_controller"):
		var ic = body.get_interaction_controller()
		ic.set_inside_interactable(null)
	pass # Replace with function body.
