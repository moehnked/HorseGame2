extends Node
class_name CardHandEvaluator


var handVals = []
var handSuites = []


var evaluation = {}

func _ready():
	#generate_random_hand()
	#print_hand(handVals, handSuites)
	#print(evaluate_hand(handVals, handSuites))
	pass

func evaluate_hand(hvs, hss):
	var ar_vals = hvs.duplicate(true)
	var flush = is_flush(hss)
	var straight = is_straight(ar_vals)
	#triple triple
	if is_triple_pair_count(ar_vals, 3):
		return 13
		pass
	else:
		#straight flush
		if flush and straight:
			return 12
		else:
			#double triple
			if is_double_pair_count(ar_vals, 3):
				return 11
			else:
				#four of a kind
				if pair_count(ar_vals, 4) != -1:
					return 10
				else:
					#full house
					if is_full_house(ar_vals):
						return 9
					else:
						#flush
						if flush:
							return 8
						#straight
						elif straight:
							return 7
						else:
							#Triple Double
							if is_triple_pair_count(ar_vals, 2):
								return 6
							#three of a kind
								if pair_count(ar_vals, 3) != -1:
									return 5
								else:
									#two pair
									if is_two_pair(ar_vals):
										return 4
									else:
										#pair or high card
										return 3 if pair_count(ar_vals, 2) != -1 else 2
	
func evaluate_self():
	return evaluate_hand(handVals, handSuites)

func get_rank_as_string(rank):
	match rank:
		10:
			return "Straight Flush"
		9:
			return "Four of a Kind"
		8:
			return "Full House"
		7:
			return "Flush"
		6:
			return "Straight"
		5:
			return "Three of a Kind"
		4:
			return "Two Pair"
		3:
			return "Pair"
		2:
			return "High Card"

func generate_random_hand():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var s = ["H", "C", "S", "D"]
	for i in range(5):
		handVals[i] = rng.randi_range(1,13)
		handSuites[i] = s[rng.randi() % 4]

func initialize(cards):
	print("initializing card hand evaluator: ", cards)
	for c in cards:
		#print(c.value)
		handVals.append(c.value)
		#print(c.get_suite_shorthand())
		handSuites.append(c.get_suite_shorthand())

func is_double_pair_count(hvs, num = 3):
	var ar = hvs.duplicate(true)
	var x = pair_count(ar, num)
	if x != -1:
		ar.erase(x)
		var y = pair_count(ar, num)
		if y != -1:
			return true
	return false

func is_four_of_a_kind(hvs):
	for c in hvs:
		if hvs.count(c) >= 4:
			return true
	return false

func is_flush(hss):
	var flush = false
	flush = hss.count("H") > 4 or hss.count("C") > 4 or hss.count("H") > 4 or hss.count("H") > 4
	return flush

func is_full_house(hvs):
	var ar = hvs.duplicate(true)
	var three = pair_count(ar, 3)
	if three != -1:
		ar.erase(three)
		var two = pair_count(ar,2)
		if two != -1:
			return true
	return false

func is_straight(hvs):
	var ar = hvs.duplicate(true)
	ar.sort()
	return is_straight_helper(0, ar)

func is_straight_helper(idx, ar):
	if idx + 1 < ar.size():
		if (ar[idx + 1] == ar[idx] + 1) or (ar[idx + 1] == ar[idx]):
			return is_straight_helper(idx + 1, ar)
		else:
			return false
	else:
		return true

func is_triple_pair_count(hvs, num = 2):
	var ar = hvs.duplicate(true)
	var x = pair_count(ar, num)
	if x != -1:
		ar.erase(x)
		var y = pair_count(ar, num)
		if y != -1:
			ar.erase(y)
			var z = pair_count(ar, num)
			if z != -1:
				return true
	return false

func is_two_pair(hvs):
	var ar = hvs.duplicate(true)
	var x = pair_count(ar, 2)
	if x != -1:
		ar.erase(x)
		var y = pair_count(ar, 2)
		if y != -1:
			return true
	return false

#check if there are x number of matching cards in the hand
#IE if the hand has a pair, a three of a kind, a four of a kind, etc
#returns the value of the card that has the matches
#returns -1 if no matches are found
func pair_count(hss, count):
	for c in hss:
		if hss.count(c) >= count:
			return c
	return -1

func print_card(val, suite):
	var suitenames = {
		"H": "Hearts",
		"C": "Clubs",
		"D": "Diamonds",
		"S": "Spades"
	}
	var v = String(val)
	match val:
		1:
			v = "Ace"
		11:
			v = "Jack"
		12:
			v = "Queen"
		13:
			v = "King"
	print(v, " of ", suitenames[suite])

func print_hand(hvs, hss):
	for i in range(hvs.size()):
		print_card(hvs[i], hss[i])
