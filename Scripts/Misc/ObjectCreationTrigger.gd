extends Spatial

export var objectPath = ""
export var triggerName = ""
export var delay = 0
export var enabled = true
export var triggerByPlayer = true
export var sfx = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger_by_name(body):
	if(body.name == triggerName):
		$Timer.start(delay)
	

func trigger_by_player(body):
	if body == Global.Player:
		$Timer.start(delay)

func _on_Area_body_entered(body):
	if enabled:
		if triggerByPlayer:
			trigger_by_player(body)
		else:
			trigger_by_name(body)
	pass # Replace with function body.


func _on_Timer_timeout():
	var obj = load(objectPath).instance()
	#owner.add_child(obj)
	Global.world.place(obj, global_transform.origin)
	if sfx != "":
			Global.AudioManager.play_sound(sfx)
	queue_free()
	pass # Replace with function body.
