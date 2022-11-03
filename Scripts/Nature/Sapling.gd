extends "res://Scripts/Nature/Tree.gd"

var progress = 0

func _ready():
	scale = Vector3.ZERO

func _process(delta):
	scale = scale.linear_interpolate((Vector3.ONE * progress / 20), 0.01)

func complete():
	Global.world.instantiate("res://prefabs/Effects/TreeFell.tscn", global_transform.origin + Vector3(0,1,0))
	Global.world.instantiate("res://prefabs/Nature/AppleTree.tscn", global_transform.origin)
	fell()

func fell():
	print("FELLING " , name, " , ", owner, owner.name)
	Global.AudioManager.play_sound_3d("res://Sounds/tree_fall_01.wav", -10, global_transform.origin, 5)
	#Utils.report_node_deletion(self)
	queue_free()

func hour_alert(h):
	progress += 5
	if progress >= 100:
		complete()

func save():
	return Utils.serialize_node(self)
