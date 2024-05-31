extends ColorRect


var bar_red = preload("res://other_images/barHorizontal_red.png")
var bar_green = preload("res://other_images/barHorizontal_green.png")
var bar_yellow = preload("res://other_images/barHorizontal_yellow.png")
var bar_blue = preload("res://other_images/barHorizontal_blue.png")
var bar_black = preload("res://other_images/barHorizontal_black.png")

func _ready():
	$Overclock/OverclockBar.texture_under = bar_black
	$Overclock/OverclockBar.texture_progress = bar_yellow
	$Shield/ShieldBar.texture_under = bar_black
	$Shield/ShieldBar.texture_progress = bar_blue
	$Drone/DroneBar.texture_under = bar_black
	$Drone/DroneBar.texture_progress = bar_blue
	$Overclock.hide()
	$Shield.hide()
	$Drone.hide()

#	hide()
#	if get_parent() and get_parent().get("MaxHP"):
#		$Overclock/OverclockBar.max_value = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Currency.text = "Galactic Credits: " + str(Globals.Currency)

	if Globals.abilities_unlocked.find("overclock") != -1:
		$Overclock.show()
	if Globals.abilities_unlocked.find("shield") != -1:
		$Shield.show()
	if Globals.abilities_unlocked.find("drone") != -1:
		$Drone.show()
	#full bar = ability ready. the bar values are multiplied by 10 for smoother movement
	$Overclock/OverclockBar.max_value = (Globals.player_reference.overclock_cooldown_max) * 10
	$Overclock/OverclockBar.value = (Globals.player_reference.overclock_cooldown_max - Globals.player_reference.overclock_cooldown) * 10
	$Shield/ShieldBar.max_value = (Globals.player_reference.shield_cooldown_max) * 10
	$Shield/ShieldBar.value = (Globals.player_reference.shield_cooldown_max - Globals.player_reference.shield_cooldown) * 10
	$Drone/DroneBar.max_value = (Globals.player_reference.drone_cooldown_max) * 10
	$Drone/DroneBar.value = (Globals.player_reference.drone_cooldown_max - Globals.player_reference.drone_cooldown) * 10
