extends Node

#global script for variables/functions/signals that carry over across the entire game

var Currency = 0

#after which boss to start (0 = start as normal)
var start_index = 0

var player_reference

var upgrademenu_reference

var weapons_unlocked : Array = ["basic_shot"]

var abilities_unlocked : Array = []

var upgrades_taken : Array = []

var upgrade_pause = false

#function is called from the player character death event
func reset_globals():
	Currency = 0
	weapons_unlocked = ["basic_shot"]
	abilities_unlocked = []
	upgrades_taken = []
	upgrade_pause = false
