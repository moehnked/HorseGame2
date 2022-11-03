extends Area2D


signal missed_note()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NoteMissed_area_entered(area):
	area.queue_free()
	emit_signal("missed_note")
	pass # Replace with function body.
