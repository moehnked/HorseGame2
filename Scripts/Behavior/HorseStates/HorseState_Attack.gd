extends "res://Scripts/Behavior/BehaviorState.gd"

class_name HorseState_Attack

func run_state(actor, delta):
	pass

func initialize(args = {}):
	pass

func check_aggro(other):
	var horse = owner
	if horse.pep < -5:
		print("horse pep low")
		if (horse.rng.randf_range(0.0, 1.0) < other.aggroable()):
			horse.set_attack_target(other)
			pass
	elif(horse.check_relationships(other) < -4):
		print("bad relationshiop")
		horse.set_attack_target(other)
		pass

func check_relations(horse, other):
	if(horse.check_relationships(other) < -4):
		print("bad relationshiop")
		horse.set_attack_target(other)
		pass
	elif(other.owner != null):
		if(horse.check_relationships(other.owner) < -4):
			print("bad relationshionp")
			horse.set_attack_target(other.owner)
			pass
		elif(other.owner.has_method("is_horse") and !horse.horseComs.has(other.owner)):
			#add to list of horses in range of tlaking
			horse.add_horse_to_coms(other.owner)
			pass
	elif(other.has_method("is_horse") and !horse.horseComs.has(other)):
		#add to list of horses in range of talking
		horse.add_horse_to_coms(other)
		pass
	pass # Replace with function body.

func _on_AggroRange_body_entered(body):
	#print(body.name,  " - entered aggro range, pep: ", owner.pep)
	var other = null
	if body.has_method("aggroable"):
		other = body
	elif body.owner != null:
		if body.owner.has_method("aggroable"):
			other = body.owner
			
	if other != null and owner.pep < -5:
		check_aggro(other)
	else:
		check_relations(owner, body)
	pass # Replace with function body.
