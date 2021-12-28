extends Control

func _ready():
	Utils.show_mouse(true)

func _on_TextureButton_pressed():
	var ps = load("res://my_scene.tscn")
	var myscene = ps.instance()
	get_tree().get_root().add_child(myscene)
	myscene.owner = get_tree().get_root()
	#get_tree().change_scene_to(ps)
	queue_free()
	pass # Replace with function body.
