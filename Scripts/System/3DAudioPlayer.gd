extends Spatial


var isWithinMaxDistance = false
var playerDist = 0

export(AudioStream) var stream
export(float, -100,100) var volumeDB = 0.0
export(bool) var playing = false
export(bool) var autoplay = false
export(bool) var streamPaused = false

export var minDist = 5
export var maxDist = 20 

var maxSqr
var minSqr
var curDBLevel = -100
var proximity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area.scale = Vector3.ONE * maxDist
	$AudioStreamPlayer.stream = stream
	$AudioStreamPlayer.volume_db = -100
	$AudioStreamPlayer.playing = playing
	$AudioStreamPlayer.autoplay = autoplay
	$AudioStreamPlayer.stream_paused = streamPaused
	minSqr = pow(minDist, 2)
	maxSqr = pow(maxDist, 2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isWithinMaxDistance:
		playerDist = global_transform.origin.distance_squared_to(Global.Player.global_transform.origin)
		proximity = 1.0 - (minSqr / playerDist)
		curDBLevel = volumeDB - (100 * clamp(proximity,0.0,1.0))
		#print("3dAduio: ", proximity, "% , ", curDBLevel)
		$AudioStreamPlayer.volume_db = lerp($AudioStreamPlayer.volume_db, curDBLevel, 0.1)
		#if playerDist < maxSqr:
	pass


func _on_Area_body_entered(body):
	if body == Global.Player:
		isWithinMaxDistance = true
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_Area_body_exited(body):
	if body == Global.Player:
		isWithinMaxDistance = false
		if $AudioStreamPlayer.playing:
			$AudioStreamPlayer.stop()
	pass # Replace with function body.
