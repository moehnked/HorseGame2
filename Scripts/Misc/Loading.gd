extends Node2D

var o = preload("res://prefabs/Misc/Frame.tscn")

func _ready():
	for i in range(120):
		var f = o.instance()
		f.initialize(i)
		$point.call("add_child", f)



func _on_Timer_timeout():
	pass # Replace with function body.
