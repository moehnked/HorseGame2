extends Node
enum context{Discard, Equip, Unequip, Use, Read}

static func get_context(i):
	match i:
		0:
			return context.Discard
		1:
			return context.Equip
		2:
			return context.Unequip
		3:
			return context.Use
		4:
			return context.Read
