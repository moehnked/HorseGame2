extends Node2D

export(Array, Resource) var failSFX
export(Array, Resource) var successSFX
export(Resource) var gamePrompt
export(Array, Resource) var minigames


var fishRef
var poleRef
var minigameRef

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	var o = gamePrompt.instance()
	add_child(o)
	o.position = Vector2(512,300)
	o.connect("fishing_prompt_done", self, "spawn_minigame")
	pass # Replace with function body.


func failure():
	print("game lost! the fish got away")
	Global.AudioManager.play_sound(Utils.get_random(failSFX))
	fishRef.queue_free()
	minigameRef.queue_free()
	get_tree().paused = false
	queue_free()

func initialize(args = {}):
	args = Utils.check(args, {"fishRef": null, "poleRef": null})
	fishRef = args["fishRef"]
	poleRef = args["poleRef"]
	#rod will have a power level
	#fish will have a level
	#both stats will affect difficulty of the minigame
	

func spawn_minigame():
	print("time to fish!!!")
	minigameRef = Utils.get_random(minigames).instance()
	Global.world.add_child(minigameRef)
	minigameRef.initialize(fishRef.get_fish_level(), 1)
	minigameRef.connect("emit_success", self, "success")
	minigameRef.connect("emit_failure", self, "failure")

func success():
	print("game won! you caught the fish")
	Global.AudioManager.play_sound(Utils.get_random(successSFX))
	minigameRef.queue_free()
	get_tree().paused = false
	queue_free()
