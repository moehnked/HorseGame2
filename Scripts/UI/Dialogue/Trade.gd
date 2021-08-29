extends "res://Scripts/UI/Dialogue/DialogueOption.gd"


export(Resource) var res


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func initialize(args = {}):
	print("Trade: initialized")
	.initialize(args)

func trigger():
	print("DO Trade: clicked")
	initArgs["ds"].start_trade(res, {"vendor":initArgs["ds"].speaker, "customer":initArgs["ds"].listener, "callback":"exit_trade", "source":initArgs["ds"]})
	

func _on_Trade_emit_selected():
	trigger()
	pass # Replace with function body.
