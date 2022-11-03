extends Control

export(Array, Texture) var hudPartyIcons

func initialize(i):
	$Frame.texture = hudPartyIcons[i]

func update_display(HP, maxhp = 10):
	$Bar.rect_size = Vector2((float(HP)/float(maxhp)) * 275, 15)
