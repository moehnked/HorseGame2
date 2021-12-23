extends Spatial

const hm = preload("res://Scripts/Statics/HorseMoods.gd")
const HorseMoods = hm.HorseMoods

var isAggroAtStart:bool = false
var mood = {
	HorseMoods.heart : 0,
	HorseMoods.diamond : 0,
	HorseMoods.club : 0,
	HorseMoods.spade : 0,
	HorseMoods.greed : 0,
	HorseMoods.bloodlust : 0,
}

var personality
var relationships = {}

func _ready():
	add_to_group("rng_dependant")
	add_to_group("HourAlert")

func calculate_charm_effect(charm, charmer):
	print(name, " RECIEVED CHARM ", charm)
	if(relationships.has(charmer)):
		relationships[charmer] += mood[charm]
	else:
		relationships[charmer] = mood[charm]
	
	if(mood[charm] > 0):
		get_parent().set_pep(get_parent().get_pep() + 1)
	elif(mood[charm] < 0):
		get_parent().set_pep(get_parent().get_pep() - 1)
	
	print(name, "'s Relationship with ", charmer.name, " increased by ", mood[charm], " to ", relationships[charmer])
	print("Pep: ", get_parent().get_pep())
	match(mood[charm]):
		2:
			$Particles.loved()
		1:
			$Particles.liked()
		0:
			pass
		-1:
			$Particles.disliked()
		-2:
			$Particles.hated()
	if(check_relationships(charmer) < -4):
		#we have made an enemy
		pass
	return mood[charm]

func calculate_random_weights():
	var ps = []
	var limit = 0.0
	var rng = Global.world.rng
	for n in range(6):
		var weight = rng.randf()
		ps.append(weight)
		limit += weight
	for n in range(6):
		ps[n] = ps[n] / limit
	return ps

func can_be_charmed():
	var state = get_parent().get_state()
	var val = ((get_parent().get_pep() > -5) and (state != "Attack" and state != "HorsDeCombat"))
	print("horse Pep:", get_parent().get_pep(), ", canBeCharmed: ",val)
	return val

func check_if_conversable(args):
	var rel = check_relationships(args.talkingToController.get_parent())
	print("checking if conversable: ", get_parent().get_pep(), " - rel: ", rel)
	#can talk
	if rel > -5:
		return get_parent().get_pep() >= 5 or rel >= 10
	else:
		return false

func check_relationships(person):
	if relationships.has(person):
		return relationships[person]
	else:
		return 0

func hour_alert():
	get_parent().set_pep(max(get_parent().get_pep() - 1, -10))
	pass

func initialize():
	initialize_personality()

func initialize_personality(mom = null, dad = null):
	if(isAggroAtStart):
		get_parent().set_pep(Global.world.rng.randi_range(-10,5))
	var moodboard = [HorseMoods.heart, HorseMoods.diamond, HorseMoods.club, HorseMoods.spade, HorseMoods.greed, HorseMoods.bloodlust]
	personality = calculate_random_weights()
	var mood_vals = [2,1,0,0,-1,-2]
	for n in mood_vals:
		var i = roll_moods(personality)
		set_moods(moodboard, i, mood_vals[n])
	moodboard = [HorseMoods.heart, HorseMoods.diamond, HorseMoods.club, HorseMoods.spade, HorseMoods.greed, HorseMoods.bloodlust]
	if(mom != null):
		var weight = 0.0
		var i = 0
		for m in mom.personality:
			if m > weight:
				weight = m
			i += 1
		set_moods(moodboard, i, 2)
	if(dad != null):
		var weight = 0.0
		var i = 0
		for m in dad.personality:
			if m > weight:
				weight = m
			i += 1
		set_moods(moodboard, i, 2)

func parse_charm(charm, charmer, spell):
	var m = 0
	match charm:
		HorseMoods.greed:
			charmer.enter_some_menu()
			var screen = load("res://prefabs/UI/InventoryScreens/GiveScreen.tscn").instance()
			screen.initialize({"vendor":charmer, "customer":owner, "inv":charmer.get_inventory(), 'source':charmer, 'callback':'exit_some_menu', 'displayName':owner.get_horse_name()})
			Global.world.add_child(screen)
			return m
		_:
			m = calculate_charm_effect(charm, charmer)
	return m

func recieve_charm(charm, charmer, spell):
	if can_be_charmed():
		print("can charm, charming...")
		var m = parse_charm(charm, charmer, spell)
		spell.set_status(true)
		return m
	else:
		#set spell status to false
		spell.set_status(false)
		pass

func roll_moods(weights):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var threshold = rng.randf_range(0.0, 1.0)
	var score = 0.0
	var i = 0
	while i < weights.size()-1 and score < threshold:
		score += weights[i]
		i += 1
	return i

func set_moods(mb, i, v):
	mood[mb[i]] = v
	personality.remove(i)
	mb.remove(i)



func _on_Horse_emit_charm_recieved(charm, charmer, spell):
	recieve_charm(charm, charmer, spell)
	pass # Replace with function body.
