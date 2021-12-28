extends ViewportContainer

var isFading = false
var initArgs = {}
var targetArgs = {}
var weight = 0.1

var postEffects = {
	'default':ShaderMaterial.new(),
	#'waterDither':preload("res://Shaders/shader/dither_water.tres"),
	'waterDither':ShaderMaterial.new(),
	'normalDither': preload("res://Shaders/shader/dither_odda.tres")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if isFading:
		modulate = modulate.linear_interpolate(Color(1,1,1,1), 0.1)
		if modulate.r >= 0.9999:
			modulate = Color(1,1,1,1)
			isFading = false
		pass

func clear():
	modulate = Color(0,0,0,1.0)
	material = ShaderMaterial.new()
	pass

func increment_fade():
	for p in initArgs.keys():
		material.set_shader_param(p, lerp(material.get_shader_param(p), initArgs[p],.1))

func set_material(key, fade = true, params = ["u_contrast"], setargs = {"u_contrast": 2.1}):
	if postEffects.keys().has(key):
		material = postEffects[key]
	else:
		material = postEffects["default"]
	if fade:
		isFading = true
		for p in params:
			initArgs[p] = material.get_shader_param(p)
		for s in setargs.keys():
			material.set_shader_param(s, setargs[s])
