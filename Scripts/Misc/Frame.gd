extends Node2D

var i = 0
var offset = 1.0

func _ready():
	#initialize(50)
	pass

func initialize(index):
	i = index
	var path = "res://scenes/horse/frame_"+get_path()+"_delay-0.04s.png"
	print("loading sprite ",path)
	$Sprite.texture = load(path)
	#offset = float(i)/float(119)
	offset = i * (float(600)/120)
	print(offset)

func get_path():
	if(i < 10):
		return "00" + String(i)
	elif(i < 100):
		return "0" + String(i)
	else:
		return String(i)

func _process(delta):
	var y = get_global_mouse_position().y
	y = 600 - y
	var x = clamp(inverse_lerp(offset - 120, offset, y),0.0,1.0)
	$Sprite.modulate.a = x
