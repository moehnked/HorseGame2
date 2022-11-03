extends Control


func play_anim(animPlayer, animName):
	var ar = get_node(animPlayer)
	if ar != null:
		ar.play(animName)
		
func load_menu():
	$PlaySound.trigger()
	$PressStart.queue_free()
	var n = load("res://prefabs/UI/MenuOptions.tscn").instance()
	add_child(n)
	n.connect("menu_executed", self, "stop_music")
	
func stop_music():
	$AudioStreamPlayer.stop()
