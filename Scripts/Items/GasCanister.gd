extends "res://Scripts/Items/Equipable.gd"

var gas:int = 100
var lookingAt = null
onready var lowestPoint = $Bottom
onready var prevLowestPoint = $Bottom
var pouringGas = false
var raycastPoint:Vector3 = Vector3()

func _ready():
	$PourGasTick.start()

func _process(delta):
	if pouringGas:
		check_raycast()
		play_sound()
	if linear_velocity <= Vector3(0.1,0.1,0.1) and not isEquipped:
		check_tip()
		if lowestPoint != prevLowestPoint:
			if not $AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.stream = load(equipSoundPath)
				raycastPoint = lowestPoint.global_transform.origin
				play_sound(-8)

func check_tip():
	var points = [get_y_value_of($Bottom),get_y_value_of($Top),get_y_value_of($Left),get_y_value_of($Right)]
	prevLowestPoint = lowestPoint
	points.sort()
	if points[0] == get_y_value_of($Bottom):
		lowestPoint = $Bottom
	if points[0] == get_y_value_of($Top):
		lowestPoint = $Top
	if points[0] == get_y_value_of($Left):
		lowestPoint = $Left
	if points[0] == get_y_value_of($Right):
		lowestPoint = $Right

func check_raycast():
	raycastPoint = $RayCast.get_collision_point()

func get_y_value_of(point):
	return point.global_transform.origin.y

func recieve_looking_at(by, obj):
	if isEquipped:
		if obj.has_method("recieve_gas"):
			lookingAt = obj
		elif obj.get_parent().has_method("recieve_gas"):
			lookingAt = obj.get_parent()

func parse_equip(args = {}):
	args = Utils.check(args, {"input":InputMacro.new()})
	input = args.input
	if input.left_mouse_pressed and not input.standard:
		pouringGas = true
	if input.standard:
		gas -= 1
		pouringGas = false
		$AudioStreamPlayer3D.stop()
	$GasolinePouring/Particles.emitting = pouringGas

func play_sound(db = 0):
	$AudioStreamPlayer3D.global_transform.origin = raycastPoint
	if not $AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.unit_db = db
		$AudioStreamPlayer3D.play()

func pour_gas():
	gas -= 1
	if lookingAt != null:
		pouringGas = not lookingAt.recieve_gas(1)

func prompt():
	return "pick up - " + String(gas) + "%"

func _on_PourGasTick_timeout():
	if pouringGas:
		pour_gas()
	$PourGasTick.start()
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	_prompt.prompt = "Pick Up ("+ String(gas) +"%)"
	pass # Replace with function body.
