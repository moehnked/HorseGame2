extends Spatial

func initialize(letter):
	print("initializing.... ", letter)
	var path = "res://models/letters/letter_" + letter +".obj"
	$MeshInstance.mesh = load(path)
	$MeshInstance.mesh.surface_set_material(0, load("res://materials/letterMaterial.tres"))
	start()

func start():
	$AnimationPlayer.play("Main")

func _ready():
	pass # Replace with function body.

