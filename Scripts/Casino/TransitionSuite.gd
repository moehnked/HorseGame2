extends Node2D

export var targetGroup = ""
export var enabled = true
var count = 0
export var delay = 10

signal transition_end()

# Called when the node enters the scene tree for the first time.
func _ready():
	if enabled:
		Global.Player.unsubscribe_to()
		Global.AudioManager.play_sound("res://Sounds/Cards_01.wav", -5)
		start_transition()
	else:
		queue_free()
	pass # Replace with function body.

func start_transition():
	for c in get_children():
		c.connect("animation_finished", self, "tick_transition")
		c.set_anim_speed(rand_range(0.7,1.4))

func tick_transition():
	count += 1
	print("tick ", count)
	if count == delay:
		print("finished")
		if targetGroup != "":
			Global.world.get_tree().call_group(targetGroup, "trigger", self)
		emit_signal("transition_end")
		#queue_free()
