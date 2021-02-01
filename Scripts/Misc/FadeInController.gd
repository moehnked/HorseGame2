extends CanvasItem

signal fade_in_complete()
signal fade_out_complete()

var alpha = 0.0
var fadeParity:int = 1
var fadeRate:float = 0.7
var isFading:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1,1,1,0)
	pass # Replace with function body.

func _process(delta):
	if isFading:
		if alpha < 0:
			isFading = false
			emit_signal("fade_out_complete")
		if alpha < 0.5:
			var a = delta * fadeParity * fadeRate
			alpha += a
			modulate = Color(1,1,1,alpha)
		if alpha >= 0.5:
			isFading = false
			emit_signal("fade_in_complete")

func start(fadein = true):
	fadeParity = 1 if fadein else -1
	isFading = true


