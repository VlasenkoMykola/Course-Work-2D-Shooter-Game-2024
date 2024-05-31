extends Node2D

var Enemy = preload("res://enemy.tscn")

var cooldown = 0
var max_cooldown = 1
var rng = RandomNumberGenerator.new()
var waves: Array
var current_wave = -1#first wave adds 1 to this number, thus resulting in waves[0]

func add_enemy_to_spawn_list_timed(type,time_second_to_spawn):
	var lambda_spawn = func ():
		spawn_enemy(type)

	var timer_tween = get_tree().create_tween()
	timer_tween.tween_property(self, "position", position, time_second_to_spawn)
	timer_tween.tween_callback(lambda_spawn)
#	var timer := Timer.new()
#	add_child(timer)
#	timer.wait_time = time_second_to_spawn
#	timer.one_shot = true
#	timer.timeout.connect(_on_timer_timeout)
#	timer.connect("timeout", spawn_enemy(type))
#	timer.start()


#removes previous waves, and gives galactic credits equal to number of money that the killed enemies would have been worth
func skip_previous_waves():
	
	#hacky workaround to check enemy drop currency
	#enemy is temporarily spawned, its variables are checked, then it is deleted

	var reference_enemy = Enemy.instantiate()
	
	var enemy_currency_drops_total = 0

	for item in waves:
		#first element is dictionary with extra data, skipping it
		for item2 in item:
			if typeof(item2) == TYPE_DICTIONARY:
				#retroactively apply background changes:
				if item2.keys().find("background_change") != -1:
					$"../ParallaxBackground".smooth_background_change(item2["background_change"])
			else:
#				print(item2)
#				print(reference_enemy.enemy_types[item2]["drop_currency"])
				enemy_currency_drops_total += reference_enemy.enemy_types[item2]["drop_currency"]

	reference_enemy.queue_free()
	
	Globals.Currency += enemy_currency_drops_total

	waves = []#emptying the waves array
	

func _ready():

#unused, was used for testing
#	spawn_ally("shotgun")
#	spawn_ally("sniper")
#	spawn_ally("machinegun_mk3")
#	spawn_ally("boss_shotgun_elite")

#	$"../ParallaxBackground".smooth_background_change("res://sbs_-_seamless_space_backgrounds_-_large_1024x1024/Large 1024x1024/Purple Nebula/Purple Nebula 8 - 1024x1024.png")

#TODO: add code to smoothly change backgrounds on certain waves	
#	$"../ParallaxBackground/ParallaxLayer/Sprite2D".texture = load("res://sbs_-_seamless_space_backgrounds_-_large_1024x1024/Large 1024x1024/Purple Nebula/Purple Nebula 1 - 1024x1024.png")

	waves.append([{}, "basic", "basic"])
	waves.append([{}, "basic", "basic", "basic"])
	waves.append([{}, "shotgun"])
	waves.append([{}, "basic", "basic", "basic", "basic"])
	waves.append([{}, "machinegun","basic"])
	waves.append([{}, "boss_shotgun"])
	if Globals.start_index == 1:
		skip_previous_waves()
	waves.append([{
		background_change = "res://sbs_-_seamless_space_backgrounds_-_large_1024x1024/Large 1024x1024/Green Nebula/Green Nebula 1 - 1024x1024.png",
	}, "shotgun", "basic", "basic", "basic"])
	waves.append([{}, "sniper","basic","basic"])
	waves.append([{}, "carrier","carrier"])
	waves.append([{}, "machinegun","machinegun","sniper"])
	waves.append([{}, "boss_multiphase1"])
	waves.append([{}, "basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic" ])
	waves.append([{}, "sniper","sniper","sniper"])
	waves.append([{}, "boss_sniper"])
	if Globals.start_index == 2:
		skip_previous_waves()
	waves.append([{
		background_change = "res://sbs_-_seamless_space_backgrounds_-_large_1024x1024/Large 1024x1024/Purple Nebula/Purple Nebula 1 - 1024x1024.png",
	}, "basic_mk2", "basic_mk2", "basic_mk2", "basic_mk2"])
	waves.append([{}, "shotgun_mk2", "basic_mk2", "basic_mk2"])
	waves.append([{}, "machinegun_mk2", "basic_mk2", "basic_mk2"])
	waves.append([{}, "sniper_mk2", "basic_mk2", "basic_mk2"])
	waves.append([{}, "carrier_mk2","carrier_mk2"])
	#massive horde of basics
	waves.append([{}, "basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic","basic", "basic", "basic" ])
	waves.append([{}, "machinegun_mk2", "shotgun_mk2", "sniper_mk2"])
	waves.append([{}, "boss_machinegun"])
	if Globals.start_index == 3:
		skip_previous_waves()
	waves.append([{
		background_change = "res://sbs_-_seamless_space_backgrounds_-_large_1024x1024/Large 1024x1024/Starfields/Starfield 7 - 1024x1024.png",		
	},"basic_mk3","basic_mk3","basic_mk3"])
	waves.append([{},"shotgun_mk3","basic_mk3"])
	waves.append([{},"machinegun_mk3","basic_mk3","basic_mk3"])
	waves.append([{},"sniper_mk3","basic_mk3","basic_mk3"])
	waves.append([{},"shotgun_mk3","machinegun_mk3"])
	#mk2 basic horde
	waves.append([{},"basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2","basic_mk2"])
	waves.append([{},"shotgun_mk3","shotgun_mk2","shotgun","shotgun"])
	waves.append([{}, "sniper_mk2", "sniper_mk2", "sniper_mk2", "sniper_mk2", "sniper_mk2"])
	waves.append([{}, "carrier_mk3","carrier_mk3"])
	waves.append([{}, "boss_carrier"])
	if Globals.start_index == 4:
		skip_previous_waves()
	waves.append([{
		background_change = "res://sbs_-_seamless_space_backgrounds_-_large_1024x1024/Large 1024x1024/Blue Nebula/Blue Nebula 6 - 1024x1024.png",
	},"machinegun_mk3","machinegun_mk3","machinegun_mk3"])
	waves.append([{}, "shotgun_mk3","sniper_mk3","machinegun_mk3","carrier_mk3"])
	#mk3 basic horde
	waves.append([{},"basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3","basic_mk3"])
	waves.append([{}, "boss_shotgun_elite"])


#old timer-based system
#	add_enemy_to_spawn_list_timed("basic", 0)
#	add_enemy_to_spawn_list_timed("basic", 1)
#	add_enemy_to_spawn_list_timed("basic", 2)
#	add_enemy_to_spawn_list_timed("shotgun", 15)
#	add_enemy_to_spawn_list_timed("machinegun", 30)
#	add_enemy_to_spawn_list_timed("boss_shotgun", 45)
#	add_enemy_to_spawn_list_timed("boss_multiphase1", 75)

func spawn_enemy(type):
	var e = Enemy.instantiate()
	e.set_enemy_type(type)
	e.position.x = rng.randi_range(300,500)
	get_tree().get_root().add_child(e)
	e.arrive_on_screen()

func spawn_ally(type):
	var e = Enemy.instantiate()
	e.set_enemy_type(type)
	e.position.x = rng.randi_range(300,500)
	e.position.y = 700
	get_tree().get_root().add_child(e)
	e.convert_to_ally()


#ignore the fact that delta is unused for now
@warning_ignore("unused_parameter")
func _process(delta):
	
	#get all enemies
	var all_enemies = get_tree().get_nodes_in_group("Enemies")
	#print number of enemies
#	print(all_enemies.size())
	
	if all_enemies.size() == 0:
		current_wave += 1
		#check whether there is a valid wave left:
		if current_wave < waves.size():
			for item in waves[current_wave]:
				if typeof(item) == TYPE_DICTIONARY:
					#the first element is a dictionary with extra params, other elements are enemies
					if item.keys().find("background_change") != -1:
						$"../ParallaxBackground".smooth_background_change(item["background_change"])
#					print(item)
				else:
					spawn_enemy(item)
		else:
			print("no more waves left")
			#TODO: add victory code here

