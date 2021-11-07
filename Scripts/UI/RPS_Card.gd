extends Control


export(Texture) var card_front
export(Texture) var card_back

export(bool) var isFlipped = false

var selected = false
var OGPos
var HoverPos

signal emit_clicked()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("float")
	$AnimationPlayer.seek(rand_range(0.0, 1.0))
	$Card.texture = card_front
	OGPos = rect_position.y
	HoverPos = OGPos - 50
	Global.InputObserver.subscribe(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position.y = lerp(rect_position.y, (HoverPos if selected else OGPos), 0.1)
	pass

func flip():
	$Card.texture = card_back if isFlipped else card_front

func parse_input(input):
	if selected and input.standard:
		emit_signal("emit_clicked")

func _on_Panel_mouse_entered():
	selected = true
	$AnimationPlayer.play("Hover")
	pass # Replace with function body.


func _on_Panel_mouse_exited():
	selected = false
	isFlipped = false
	flip()
	$AnimationPlayer.play("float")
	$AnimationPlayer.seek(rand_range(0.0, 1.0))
	pass # Replace with function body.
