extends Node

var AudioManager
var GCR
var GIR
var InputObserver
var InteractionPrompt
var Player
var PlayerRaycastVert
var world
var SEM
var Sun
var StatusPrompt
var WorldViewport
var Generator
var SkyController
var RSG = preload("res://Scripts/Statics/RSG.gd")

func method(ref, method, isDeferred = false):
	if isDeferred:
		pass
