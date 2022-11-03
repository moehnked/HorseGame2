extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Interactable.beingLookedAtBy != null:
		$LOD_VisibleToggle.show()
	else:
		$LOD_VisibleToggle.hide()
	pass


func _on_Interactable_emit_looking_at(_lookedAtBy):
#	$LOD_VisibleToggle.show()
	pass # Replace with function body.
