extends Area

var isOpen = false
var ocupiers = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if ocupiers > 0 and not isOpen:
#		isOpen = true
#		$AnimationPlayer.play("Open")
#	elif ocupiers == 0 and isOpen:
#		$AnimationPlayer.play("Close")
#		isOpen = false
	pass


func _on_EDoor_body_entered(body):
	#ocupiers += 1
	if not isOpen:
		$AnimationPlayer.play("Open")
		isOpen = true
	pass # Replace with function body.


func _on_EDoor_body_exited(body):
	#ocupiers -= 1
	if isOpen and get_overlapping_bodies().size() <= 1:
		$AnimationPlayer.play("Close")
		isOpen = false
	pass # Replace with function body.
