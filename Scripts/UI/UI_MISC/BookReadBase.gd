extends Node2D

signal emit_pickup(_controller, gui)

export var bookData = {
	"text":[
		"Concerning the hiring \nof \nhorse-drawn vehicles",
		"All horse-drawn vehicles of the civillian population being urgently required for agricultural purposes,",
		"no horse-drawn vehicle may be hired out to Furlong units or for any other except agricultural purposes,",
		"unless permission has been granted in advance by the guild."
	],
	"title":"Concerning the hiring of horse-drawn vehicles",
}
var interactionController
var lastPage = 1

var pages_turned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("InvScreen", "pause")
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("page_right"):
		next_page()
	if Input.is_action_just_pressed("page_left"):
		prev_page()
	if Input.is_action_just_released("ui_cancel"):
		$deload_delay.start()
	if Input.is_action_just_pressed("engage") and interactionController != null:
		emit_signal("emit_pickup", interactionController, self)
		$deload_delay.start()

func deload():
	if interactionController == null:
		get_tree().call_group("InvScreen", "unpause")
	else:
		get_tree().paused = false
	queue_free()

func initialize(_book, _controller = null):
	get_tree().paused = true
	bookData = _book
	lastPage = bookData["text"].size() - 1
	display_pages()
	$Open.play()
	interactionController = _controller

func next_page():
	if pages_turned < lastPage:
		pages_turned += 2
		$next.play()
		display_pages()

func prev_page():
	if pages_turned > 0:
		pages_turned -= 2
		$prev.play()
		display_pages()

func display_pages():
	if pages_turned == 0:
		$Container/leftSide/leftPage.visible = false
		$leftPageText.text = ""
		$leftPageNumber.text = ""
		$Container/rightSide/rightPage.visible = true
		$rightPageText.align = Label.ALIGN_CENTER
		$rightPageText.text = bookData["text"][0]
		$rightPageNumber.text = ""
	elif pages_turned <= lastPage:
		$Container/leftSide/leftPage.visible = true
		$Container/rightSide/rightPage.visible = true
		$leftPageText.text = bookData["text"][pages_turned - 1]
		$leftPageNumber.text = str(pages_turned - 1)
		$rightPageText.align = Label.ALIGN_LEFT
		$rightPageText.text = bookData["text"][pages_turned]
		$rightPageNumber.text = str(pages_turned)
	elif pages_turned - 1 == lastPage:
		$Container/rightSide/rightPage.visible = false
		$rightPageText.text = ""
		$rightPageNumber.text = ""
		$leftPageText.text = bookData["text"][lastPage]
		$leftPageNumber.text = str(lastPage)
