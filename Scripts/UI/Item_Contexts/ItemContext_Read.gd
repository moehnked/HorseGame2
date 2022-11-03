extends TextureButton

var item

func initialize(args = {}):
	args = Utils.check(args, {"item":null})
	item = args.item

func press_context():
	item.read_book()
	pass # Replace with function body.
