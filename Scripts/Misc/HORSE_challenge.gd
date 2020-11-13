extends Spatial

var balls = []
var horses = []
var hoops = []


# Called when the node enters the scene tree for the first time.
func _ready():
	print("time to play ball......")
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if(body.has_method("is_horse")):
		if body.can_play_horse():
			print(body.name, "can play...")
			horses.append(body)
	if(body.get_node("Item") != null):
		print("found node with area")
		if(body.get_node("Item").has_method("is_basketball")):
			print("found a ball....", body.name)
			balls.append(body)
	if(body.has_method("is_hoop")):
		print("found basket...", body.name)
		hoops.append(body)
	pass # Replace with function body.


func _on_TTL_timeout():
	if(horses.size() > 0 and balls.size() > 0 and hoops.size() > 0):
		print(horses[0].name, " is ready to play")
		horses[0].start_playing_horse(balls[0].get_node("Item"), hoops[0])
	else:
		print("no one could play")
	queue_free()
	pass # Replace with function body.
