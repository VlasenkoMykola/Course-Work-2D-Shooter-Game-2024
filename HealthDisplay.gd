extends Node2D

var bar_red = preload("res://other_images/barHorizontal_red.png")
var bar_green = preload("res://other_images/barHorizontal_green.png")
var bar_yellow = preload("res://other_images/barHorizontal_yellow.png")
var bar_black = preload("res://other_images/barHorizontal_black.png")

func _ready():
	$HealthBar.texture_under = bar_black
	hide()
	if get_parent() and get_parent().get("MaxHP"):
		$HealthBar.max_value = get_parent().MaxHP

func _process(delta):
	global_rotation = 0

func update_healthbar(value):
#	print("health updated")

	#updating just in case max hp got updated:

	$HealthBar.max_value = get_parent().MaxHP
	
	$HealthBar.texture_progress = bar_green
	if value < $HealthBar.max_value * 0.7:
		$HealthBar.texture_progress = bar_yellow
	if value < $HealthBar.max_value * 0.35:
		$HealthBar.texture_progress = bar_red
	if value >= $HealthBar.max_value:
		hide()
	if value < $HealthBar.max_value:
		show()
	$HealthBar.value = value
