extends Control

func _ready():
	#var rng = RandomNumberGenerator.new()
	#rng.randomize()
	#var i = rng.randi_range(0,4)
	#$Frame.texture = load("res://Sprites/UI/HUD_Party_BG_0" + String(i) + ".png")
	pass

func initialize(i):
	$Frame.texture = load("res://Sprites/UI/HUD_Party_BG_0" + String(i + 1) + ".png")

func update_display(HP, maxhp = 10):
	$Bar.rect_size = Vector2((float(HP)/float(maxhp)) * 275, 25)
