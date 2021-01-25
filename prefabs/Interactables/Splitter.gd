extends Spatial

enum State {Splitting, Retracting, Idle}

var state = State.Idle
var running:bool = false


func _ready():
	$splitter2/Anim1.play("splitterControlAction")
	$splitter2/Anim2.play("splitterHoseAction")
	$splitter2/Anim3.play("splitterHose2Action")

func _process(delta):
	set_animation_playback(running)
	match state:
		State.Retracting:
			plunge_wedge(delta, false)
		State.Splitting:
			plunge_wedge(delta)

func plunge_wedge(delta, plunge = true):
	if running:
		if plunge:
			if $Splitter_Wedge.transform.origin.x < 0.647:
				$Splitter_Wedge.transform.origin.x += 0.1 * delta
		else:
			if $Splitter_Wedge.transform.origin.x > -0.443:
				$Splitter_Wedge.transform.origin.x -= 0.1 * delta
			else:
				state = State.Idle
	else:
		state = State.Idle

func set_animation_playback(isPlaying):
	$splitter2/Anim1.playback_speed = 1 if isPlaying else 0
	$splitter2/Anim2.playback_speed = 1 if isPlaying else 0
	$splitter2/Anim3.playback_speed = 1 if isPlaying else 0

func _on_Lever_pull(controller):
	print("engaging wedge...")
	state = State.Splitting
	pass # Replace with function body.


func _on_Lever_stop():
	print("disengaging wedge....")
	state = State.Retracting
	pass # Replace with function body.


func _on_Engine_toggle_engine(state):
	running = state
	pass # Replace with function body.


func _on_Interactable_interaction(controller):
	var c = controller
	if controller.has_method("get_equipment_manager"):
		c = controller.get_equipment_manager()
	Utils.uPrint("placing logs", self)
	if Utils.contains("Log", c.get_inventory()):
		var l = Utils.pop_item_by_name("Log", c.get_inventory())
		Utils.uPrint("controller has logs...", self)
		#var obj = Global.world.instantiate(l.prefabPath, $Interactable.global_transform.origin)
		var obj = Utils.instance_item(l)
		obj.global_transform.origin = $Interactable.global_transform.origin
		obj.rotation_degrees.y = rotation_degrees.y + 90
		
	pass # Replace with function body.


func _on_WedgeCollision_area_entered(area):
	if area.has_method("split"):
		area.split()
	pass # Replace with function body.


func _on_WedgeCollision_body_entered(body):
	if body.has_method("split"):
		body.split()
	pass # Replace with function body.
