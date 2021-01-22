extends Spatial

var isRunning:bool = false
var gas:int = 100
var usingGasPrompt = false

signal toggle_engine(state)

func _ready():
	$engine/AnimationPlayer2.play("EngineAnimation")
	$engine/AnimationPlayer2.playback_speed = 0

func _process(delta):
	if isRunning:
		if not check_gas():
			toggle_isRunning()
	modulate_engine_volume(delta)

func check_gas():
	return gas > 0.0

func play_running_sound():
	$RunningSound.play()

func play_startup_sound():
	$StartupSound.play()
	pass

func modulate_engine_volume(delta):
	if isRunning:
		if $RunningSound.unit_db < 7:
			$RunningSound.unit_db += 2
	elif $RunningSound.unit_db > -100:
			$RunningSound.unit_db -= 1

func recieve_gas(amount):
	gas += amount
	return gas < 100

func toggle_isRunning():
	isRunning = !isRunning
	if isRunning and check_gas():
		play_running_sound()
	else:
		isRunning = false
	$engine/AnimationPlayer2.playback_speed = 2 if isRunning else 0
	emit_signal("toggle_engine", isRunning)
	play_startup_sound()

func _on_Interactable_interaction(controller):
	toggle_isRunning()
	pass # Replace with function body.


func _on_Interactable_emit_prompt(_prompt):
	if usingGasPrompt:
		_prompt.prompt = "[click]: Add Gasoline "+ String(gas) + "% | Turn On "
		return
	_prompt.prompt = "Turn " + ("Off" if isRunning else "On") + " - " + String(gas) + "%"
	pass # Replace with function body.


func _on_GasConsumptionTick_timeout():
	if isRunning:
		gas -= 1
	pass # Replace with function body.


func _on_Interactable_emit_looking_at(_lookedAtBy):
	if _lookedAtBy == null:
		usingGasPrompt = false
		return
	if _lookedAtBy.has_method("get_equipped"):
		var e = _lookedAtBy.get_equipped()
		if e != null:
			if e.has_method("pour_gas"):
				usingGasPrompt = true
	pass # Replace with function body.
