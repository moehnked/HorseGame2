extends TextureButton

signal emit_focus_entered(n)

export(bool) var isAdjusting = true

export(Texture) var icon

var nextPos = Vector2()

func _ready():
	if isAdjusting:
		nextPos = rect_rotation
	connect("pressed", self, "selection_sound")

func _process(delta):
	if isAdjusting:
		rect_position = rect_position.linear_interpolate(nextPos, 0.1)

func gain_focus():
	emit_signal("emit_focus_entered", self)
	#Global.AudioManager.play_sound("res://Sounds/UI_Select_A.wav",1)

func mouse_enter():
	grab_focus()
	
func mouse_exit():
	release_focus()

func selection_sound():
	Global.AudioManager.play_sound("res://Sounds/Audio/select_005.ogg", -5)

func set_offset(vec):
	nextPos = vec
	pass
