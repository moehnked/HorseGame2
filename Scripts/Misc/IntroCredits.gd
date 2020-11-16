extends Control

var cat_index = -1
export var credits = {}
var cat_sequence = ["GAME DESIGN", "ART BY", "MUSIC", "ADDITIONAL ART", "ADDITIONAL PROGRAMMING"]
var fading_in = []
var fading_out = []
var person_index = -1
var queue_fade_out = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$TTL.start(80)
	$AnimationPlayer.playback_speed = 0.5
	$AnimationPlayer.play("Fadein")

func _on_TTL_timeout():
	queue_free()
	pass # Replace with function body.
