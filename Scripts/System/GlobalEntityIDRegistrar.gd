extends Node

var entityCount = 0
var highestLoadedEID = 0

var entityIDs = {}

func _ready():
	Global.GEIDR = self

func checkLoadedEIDs(id):
	if id > highestLoadedEID:
		highestLoadedEID = id

func generate_uid(entity):
	entity.set_uid(entityCount)
	register(entity)
	entityCount += 1
	return entity.get_uid()

func get_entity(id):
	return entityIDs[id]

func get_id(entity):
	for e in entityIDs.values():
		if e == entity:
			return e.get_uid()
	return -1

func register(entity):
	var uid = entity.get_uid()
	entityIDs[uid] = entity
	if uid >= entityCount:
		entityCount = uid + 1

func truncate():
	if entityCount > (highestLoadedEID + 1):
		for e in entityIDs.keys():
			if e > highestLoadedEID:
				entityIDs.erase(e)
		entityCount = highestLoadedEID + 1


