extends Node

var allCardInPlay = []
var burn = null
var cardsInHand = []
var CHEref = null
var discard = null
var road = []
var movescores = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	CHEref = load("res://prefabs/Casino/CardGames/CardHandEvaluator.tscn")
	pass # Replace with function body.

func initialize(h, r, b, d):
	cardsInHand = h.duplicate(true)
	road = r.duplicate(true)
	burn = b.duplicate(true)
	discard = d.duplicate(true)
	permute_moves()

func permute_moves():
	score_swaps()

func score_swaps():
	for c in cardsInHand:
		var che = CHEref.instance()
		che.initialize()
		
