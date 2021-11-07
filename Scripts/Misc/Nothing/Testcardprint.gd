extends Node2D


var deck = range(0,52)


# Called when the node enters the scene tree for the first time.
func _ready():
	print(deck)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if deck.size() > 0:
		var ID = deck.pop_front()
		var value = (ID % 13) + 1
		var suite = ID % 4
		var s = "Hearts"
		match suite:
			0:
				s = "Hearts"
			1:
				s = "Clubs"
			2:
				s = "Diamonds"
			3:
				s = "Spades"
				
		print("card ID: ", ID, " - ", value, " of ", s)
#	pass
