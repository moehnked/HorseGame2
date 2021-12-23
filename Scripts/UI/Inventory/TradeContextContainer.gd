extends "res://Scripts/UI/Inventory/ContextOptionsContainer.gd"

func clear_context():
	$TextureButton.disable()

func show_context(i):
	$TextureButton.initialize({"item":i, "controller":owner.initArgs['customer']})
	$TextureButton.grab_focus()

