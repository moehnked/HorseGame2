extends ViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Weather = self
	pass # Replace with function body.

func set_weather_alpha(child, alpha):
	child.modulate = Color(1,1,1,alpha)

func update_weather(typeName, val):
	match typeName:
		"snow":
			set_weather_alpha($LightSnow, val)
