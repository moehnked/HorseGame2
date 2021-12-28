extends "res://Scripts/UI/GenericMenu.gd"

func _ready():
	._ready()
	if Global.InputObserver.isJoypadMode:
		$Node2D/PauseFrame/Container/SaveWorld.grab_focus()

func save():
	#Global.world.call_deferred("save_world")
	prevMenuRef.call("queue_save_world")
	deload()
