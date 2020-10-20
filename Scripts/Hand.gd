extends StaticBody

func update_hand_sprite(spell):
	print("applying")
	apply_texture($MeshInstance, "res://Textures/Hand_" + spell + ".png")
	$AnimationPlayer.play(spell)
	
func idle_hand():
	print("returning hand to idle")
	$AnimationPlayer.play("Idle")
	apply_texture($MeshInstance, "res://Textures/Hand_idle.png")

func apply_texture(mesh_instance_node, texture_path):
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(texture_path)
	texture.create_from_image(image)
	mesh_instance_node.get_surface_material(0).albedo_texture = texture
	
func _ready():
	$AnimationPlayer.play("Idle")
