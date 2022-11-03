extends Node

var AlertJournalUpdate
var AudioManager
var GCR
var GEIDR
var Generator
var GIR
var InputObserver
var InteractionPrompt
var Player
var PlayerRaycastVert
var QuestJournal
var SEM
var Sun
var StatusPrompt
var SkyController
var RSG = preload("res://Scripts/Statics/RSG.gd")
var Weather
var world
var WorldViewport

func method(ref, method, isDeferred = false):
	if self[ref] != null:
		if isDeferred:
			self[ref].call_deferred(method)
		else:
			self[ref].call(method)
