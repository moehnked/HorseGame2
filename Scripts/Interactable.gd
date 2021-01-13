extends Area

var isInteractable = true

export var pickup_sound:String = "res://Sounds/pop_01.wav"

func add_to_inventory(controller):
	if(Utils.get_inventory(controller) != null and isInteractable):
		#var o = owner
		#controller.inventory.append(self.duplicate()) if o == null else controller.inventory.append(owner.duplicate())
		var o = self.duplicate()
		controller.inventory.append(o)
		Global.AudioManager.play_sound(pickup_sound, -3)
		return o

func interact(controller):
	add_to_inventory(controller)

func set_interactable(i = true):
	isInteractable = i
