extends MeshInstance


enum State {FADEIN, FADEOUT, IDLE}
var state = State.IDLE
var alpha = 1.0
var alphaLimit = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		State.FADEIN:
			fadein()
		State.FADEOUT:
			fadeout()

func begin_fadeout():
	alpha = alphaLimit
	state = State.FADEOUT
	pass

func begin_fadein(al = 1.0):
	print("skymesh: ", name, " beginning fadein!")
	alphaLimit = al
	alpha = 0.0
	state = State.FADEIN
	pass

func fadein():
	alpha += 0.01
	get_surface_material(0).set_shader_param("finalAlpha", alpha)
	if alpha >= alphaLimit:
		print("skymesh: ", name, " finished fadein")
		state = State.IDLE

func fadeout():
	alpha -= 0.01
	get_surface_material(0).set_shader_param("finalAlpha", alpha)
	if alpha <= 0.0:
		state = State.IDLE
