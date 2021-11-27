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
		#print("Sky Controller: lerping ", envRes.ambient_light_color.gray(), " to ",curColor.gray() )
		lerp_color()
		if abs(curColor.gray() - envRes.ambient_light_color.gray()) < 0.02:
			#print("Sky Controller: finished updating global lighting")
			lightingTransition = false
	match state:
		State.transitioning:
			$Sprite.modulate.a = lerp($Sprite.modulate.a, 0.0, 0.01)
			print()
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

func get_sky():
	return curSkyName

func set_sky(skyName):
	var m = skys[skyName]
	print("Skycontroller: ", m)
	$Sprite2.material = skys[skyName]
	$Sprite2.visible = true
	state = State.transitioning
	curSkyName = skyName
	pass

func set_global_lighting(color, lerpWeight = 0.01, fogEnabled = true):
	print("Sky controller: updating lighting")
	ltr = lerpWeight
	curColor = color
	lightingTransition = true
	envRes.fog_enabled = fogEnabled
