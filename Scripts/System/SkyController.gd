extends Node2D

onready var envRes = preload("res://default_env.tres")

export(Dictionary) var skys = {}

enum State{swap, normal, transitioning}

var curColor = Color(1,1,1,1)
var curSkyName = "day"
var state = State.normal
var lightingTransition = false
var ltr = 0.01


func _ready():
	Global.SkyController = self
	pass

func _process(delta):
	if lightingTransition:
		lerp_color()
		if abs(curColor.gray() - envRes.ambient_light_color.gray()) < 0.02:
			lightingTransition = false
	match state:
		State.transitioning:
			$Sprite.modulate.a = lerp($Sprite.modulate.a, 0.0, 0.01)
			if $Sprite.modulate.a <= 0.01:
				print("sky completed transition")
				$Sprite.visible = false
				state = State.swap
		State.swap:
			$Sprite.material = $Sprite2.material
			$Sprite.modulate = Color(1,1,1,1)
			$Sprite.visible = true
			$Sprite2.material = CanvasItemMaterial.new()
			$Sprite2.visible = false
			state= State.normal

func lerp_color():
	var r = lerp(envRes.ambient_light_color.r, curColor.r, ltr)
	var g = lerp(envRes.ambient_light_color.g, curColor.g, ltr)
	var b = lerp(envRes.ambient_light_color.b, curColor.b, ltr)
	var a = lerp(envRes.ambient_light_color.a, curColor.a, ltr)
	envRes.ambient_light_color = Color(r,g,b,a)

func get_environment():
	var e = {}
	e['anvcolor'] = envRes.ambient_light_color
	e['curcolor'] = curColor
	e['ltr'] = ltr
	e['fog'] = envRes.fog_enabled
	return e

func get_sky():
	return curSkyName

func hour_alert(hour):
	print("SkyController: ", hour)
	match hour:
		3:
			set_sky("day")
			set_global_lighting(Color(1,1,1,1), 0.0005, false)
		16:
			set_sky("late")
			set_global_lighting(Color(0.1,0,0,1), 0.0005, false)
		20:
			set_sky("night")
			set_global_lighting(Color(0,0,0.15,1), 0.0005, false)
	pass

func set_sky(skyName):
	var m = skys[skyName]
	#print("Skycontroller: ", m)
	$Sprite2.material = skys[skyName]
	$Sprite2.visible = true
	state = State.transitioning
	curSkyName = skyName
	pass

func set_global_lighting(color, lerpWeight = 0.01, fogEnabled = true):
	#print("Sky controller: updating lighting")
	ltr = lerpWeight
	if color is String:
		color = Utils.string2color(color)
	curColor = color
	lightingTransition = true
	envRes.fog_enabled = fogEnabled
