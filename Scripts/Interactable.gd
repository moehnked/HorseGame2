extends Area

var isInteractable = true

func add_to_inventory(controller):
	if(Utils.get_inventory(controller) != null and isInteractable):
		#var o = owner
		#controller.inventory.append(self.duplicate()) if o == null else controller.inventory.append(owner.duplicate())
		controller.inventory.append(self.duplicate())

func interact(controller):
	add_to_inventory(controller)

func set_interactable(i = true):
	isInteractable = i
