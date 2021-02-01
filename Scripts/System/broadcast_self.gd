extends Node

signal broadcast_self(obj)

func _ready():
	emit_signal("broadcast_self", self)
