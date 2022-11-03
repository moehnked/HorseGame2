extends Node

const itemRefs = {
	"Atlantic Horse Mackerel": "res://prefabs/Items/AtlanticHorseMackerel.tscn",
	"Apple":"res://prefabs/Items/Apple.tscn",
	"Apple Tree Sapling": "res://prefabs/Items/SaplingStarter.tscn",
	"Cryptic Apocrypha": "res://prefabs/Items/CrypticApocrypha.tscn",
	"Basketball":"res://prefabs/Items/Basketball.tscn",
	"Fishing Pole": "res://prefabs/Items/FishingPole.tscn",
	"Fossil":"res://prefabs/Items/Fossil.tscn",
	"Gas Can":"res://prefabs/Items/GasCanister.tscn",
	"Glue":"res://prefabs/Items/Glue.tscn",
	"Handaxe":"res://prefabs/Items/Handaxe.tscn",
	"Jetpack":"res://prefabs/Items/Jetpack.tscn",
	"Land Claim":"res://prefabs/Items/LandClaim.tscn",
	"Lamp":"res://prefabs/Items/Lamp.tscn",
	"Logs":"res://prefabs/Items/Logs.tscn",
	"Mallet":"res://prefabs/Items/Mallet.tscn",
	"Perfume Bottle": "res://prefabs/Items/PerfumeBottle.tscn",
	"Plank":"res://prefabs/Items/Plank.tscn",
	"Property Application":"res://prefabs/Items/PropertyApplication.tscn",
	"Rock":"res://prefabs/Items/Rock.tscn",
	"The Boogie Wara":"res://prefabs/Items/Hat1.tscn",
	"The Longest John":"res://prefabs/Items/Hat2.tscn",
	"The Sportsnap":"res://prefabs/Items/Hat3.tscn",
	"The Calling Stetson":"res://prefabs/Items/Hat4.tscn",
	
}

static func get_ref(itemName):
	return itemRefs[itemName] if itemRefs.keys().has(itemName) else null
