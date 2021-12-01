extends Node2D

var o = preload("res://prefabs/Misc/Frame.tscn")
export (NodePath) var targetEvent = null
export (String) var groupTarget = ""
var isFading = false

func _ready():
	Utils.show_mouse()
	for i in range(120):
		var f = o.instance()
		f.initialize(i)
		$point.call("add_child", f)

func _process(delta):
	if isFading:
		modulate.a = lerp(modulate.a, 0.0, 0.07)
	if modulate.a < 0.01:
		queue_free()
		Utils.capture_mouse()
	pass

func _on_Timer_timeout():
	if targetEvent != null:
		var g = get_node(targetEvent)
		g.trigger(self)
	if groupTarget != "":
		get_tree().call_group(groupTarget, "trigger", self)
	isFading = true
	
	pass # Replace with function body.
