extends RichTextLabel

var promptString
var isComplete = false

func initialize(args = {}):
	args = Utils.check(args, {"text": "null", "completed": true})
	promptString = args.text
	isComplete = args.completed
	set_look()

func set_look():
	bbcode_enabled = true
	if isComplete:
		bbcode_text = "[s]" + promptString + "[/s]"
		modulate = Color(1,1,1,0.5)
	else:
		bbcode_text = promptString
