#InteractableObject.gd
extends Area

var beingLookedAtBy = null
var isInteractable:bool = true

export var interactSound:String = "res://Sounds/equipment_02.wav"
export var isHoldToInteract:bool = false
export var playSoundOnInteract:bool = true
export var prompt = ""

signal interaction(controller)
signal holding(controller)
signal release()
signal emit_prompt(_prompt)
signal emit_looking_at(_lookedAtBy)

func _input(ev):
	if Input.is_key_pressed(KEY_E):
		if beingLookedAtBy != null and isHoldToInteract:
			emit_signal("holding", beingLookedAtBy)
		pass

func _process(delta):
	if beingLookedAtBy != null:
		if beingLookedAtBy.has_method("get_looking_at"):
			if not check_if_being_looked_at(beingLookedAtBy.get_looking_at()):
				beingLookedAtBy = null
				emit_signal("emit_looking_at", null)
				emit_signal("release")

func check_if_being_looked_at(compare):
	if compare == self:
		return true
	return false

func recieve_looking_at(controller):
	beingLookedAtBy = controller
	emit_signal("emit_looking_at", beingLookedAtBy)

func interact(controller):
	if isInteractable:
		emit_signal("interaction", controller)
		if playSoundOnInteract:
			play_sound(interactSound)
	pass

func play_sound(path):
	$AudioStreamPlayer3D.stream = load(path)
	$AudioStreamPlayer3D.play()

func prompt():
	emit_signal("emit_prompt", self)
	return prompt

func set_interactable(state = true):
	isInteractable = state
	for o in get_children():
		if o is CollisionShape:
			o.disabled = not isInteractable
