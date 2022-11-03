extends Control

var queued_method = ""

signal menu_executed()

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/NewGame.grab_focus()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_released("standard"):
		$Fadeout.play("default")
		hide_ui()
		emit_signal("menu_executed")
		match get_focus_owner().name:
			"NewGame":
				$newGameSound.trigger()
				queued_method = "start_new_game"
				#get_tree().change_scene("res://scenes/GameScene.tscn")
			"Load":
				$loadGameSound.trigger()
				queued_method = "load_game"
				#get_tree().change_scene("res://scenes/LoadWorld.tscn")
			"Quit":
				quit_game()

func fade_ended():
	call(queued_method)

func hide_ui():
	$HorseSelector.queue_free()
	$VBoxContainer.queue_free()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		$error.trigger()
	else:
		get_tree().change_scene("res://scenes/LoadWorld.tscn")

func start_new_game():
	var files = [
		"user://completedquests.json",
		"user://questlog.json",
		"user://gallery.json",
		"user://savegame.save"
	]
	var dir = Directory.new()
	for f in files:
		dir.remove(f)
	get_tree().change_scene("res://scenes/Misc/pregamePrompts.tscn")

func update_focus():
	var n = get_focus_owner()
	$HorseSelector.position.y = n.rect_position.y + $VBoxContainer.rect_position.y
	$Select.trigger()
	pass

func quit_game():
	get_tree().quit()
