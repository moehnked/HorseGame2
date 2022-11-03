extends Control

#catch at 290, escape at 30
signal emit_failure()
signal emit_success()

export(Array, Resource) var sfx
export(Gradient) var colorProgress

var nextIndex = 0
var reelTargetRot = 0
var targets = []

var fishEscaping = true
var fishPullPoint = 0
var fishLevel = 1
var rodPower = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.show_mouse(true)
	targets = $Container.get_children()
	for c in targets:
		c.connect("emit_mouse_enter", self, "check_mouse_target")
	pass # Replace with function body.

func _process(delta):
	$reel/reel_handle.rotation_degrees = lerp($reel/reel_handle.rotation_degrees, reelTargetRot, 0.5)
	if fishEscaping:
		fish_escape()
	else:
		pull_fish()
	update_progress()

func initialize(_fishLevel, _rodPower):
	fishLevel = _fishLevel
	rodPower = _rodPower

func check_mouse_target(mt):
	if targets.find(mt) == nextIndex:
		nextIndex = (nextIndex + 1) % targets.size()
		spin_rod()

func fish_escape():
	$fish.position.y -= 0.2 * fishLevel
	if $fish.position.y < 30:
		#fish escaped
		emit_signal("emit_failure")
		pass
	pass

func pull_fish():
	$fish.position.y = lerp($fish.position.y, fishPullPoint, 0.2)
	if $fish.position.y > 289:
		#capture the fish
		emit_signal("emit_success")
		pass

func spin_rod():
	var val = Utils.get_rng().randi_range(5,30) * rodPower
	Global.AudioManager.play_sound(Utils.get_random(sfx))
	#var val = 15
	reelTargetRot += val
	fishPullPoint = $fish.position.y + val
	fishEscaping = false
	$Timer.start()

func update_progress():
	var prog = ($fish.position.y - 30) / 260
	$ColorRect.color = colorProgress.interpolate(prog)
	pass


func _on_Timer_timeout():
	fishEscaping = true
	print("fish is pulling away")
	pass # Replace with function body.
