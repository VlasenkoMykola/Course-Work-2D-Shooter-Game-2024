extends Control

var button_upgrade = preload("res://upgrade_button.tscn")

var upgrade_buttons : Dictionary = {
	"upgrade_HP": {
		text = "+25 Max HP - 25 galactic credits",
		cost = 25,
		lambda_func = func(): 
			Globals.player_reference.MaxHP += 25
			Globals.player_reference.HP += 25
			,
	},
	"upgrade_HP2": {
		text = "+25 Max HP - 50 galactic credits",
		cost = 50,
		required_upgrades = ["upgrade_HP"],
		lambda_func = func(): 
			Globals.player_reference.MaxHP += 25
			Globals.player_reference.HP += 25
			,
	},
	"upgrade_HP3": {
		text = "+50 Max HP - 100 galactic credits",
		cost = 100,
		required_upgrades = ["upgrade_HP2"],
		lambda_func = func(): 
			Globals.player_reference.MaxHP += 50
			Globals.player_reference.HP += 50
			,
	},
	"upgrade_HP4": {
		text = "+50 Max HP - 250 galactic credits",
		cost = 250,
		required_upgrades = ["upgrade_HP3"],
		lambda_func = func(): 
			Globals.player_reference.MaxHP += 50
			Globals.player_reference.HP += 50
			,
	},
	"upgrade_HP5": {
		text = "+50 Max HP - 500 galactic credits",
		cost = 500,
		required_upgrades = ["upgrade_HP4"],
		lambda_func = func(): 
			Globals.player_reference.MaxHP += 50
			Globals.player_reference.HP += 50
			,
	},
	"upgrade_regen": {
		text = "Faster HP Regen - 50 galactic credits",
		cost = 50,
		lambda_func = func(): 
			Globals.player_reference.regen_rate += 1.5
			,
	},
	"upgrade_regen2": {
		text = "Even Faster HP Regen - 100 galactic credits",
		required_upgrades = ["upgrade_regen","upgrade_HP2"],
		cost = 100,
		lambda_func = func(): 
			Globals.player_reference.regen_rate += 1.5
			,
	},
	"upgrade_regen3": {
		text = "Even Faster HP Regen - 250 galactic credits",
		required_upgrades = ["upgrade_regen2","upgrade_HP3"],
		cost = 250,
		lambda_func = func():
			Globals.player_reference.regen_rate += 1.5
			,
	},
	"upgrade_regen4": {
		text = "Even Faster HP Regen - 500 galactic credits",
		required_upgrades = ["upgrade_regen3","upgrade_HP4"],
		cost = 500,
		lambda_func = func():
			Globals.player_reference.regen_rate += 1.5
			,
	},
	"upgrade_movespeed": {
		text = "Faster_movement_speed - 25 galactic credits",
		cost = 25,
		lambda_func = func(): 
			Globals.player_reference.SPEED += 100,
	},
	"upgrade_basic_firing_rate": {
		text = "Slightly Faster Basic Shot firing rate - 15 galactic credits",
		cost = 15,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("basic_shot","firing_rate",0.8)
			,
	},
	"upgrade_basic_firing_rate2": {
		text = "Even Faster Basic Shot firing rate - 40 galactic credits",
		required_upgrades = ["upgrade_basic_firing_rate"],
		cost = 40,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("basic_shot","firing_rate",0.8)
			,
	},
	"upgrade_basic_firing_rate3": {
		text = "Even Faster Basic Shot firing rate - 100 galactic credits",
		required_upgrades = ["upgrade_basic_firing_rate2"],
		cost = 100,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("basic_shot","firing_rate",0.8)
			,
	},
	#todo: make machinegun and trishot mutually exclusive:
	#on second thought, it might not even be that bad, and helps stand out from the shotgun more
	"upgrade_basic_machinegun": {
		text = "Rapid Fire: Doubled Basic Shot firing rate \n but significantly increased spread - 30 galactic credits",
		cost = 30,
		#TODO
#		exclude_upgrades = ["upgrade_basic_tri_shot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("basic_shot","firing_rate",0.5)
			Globals.player_reference.upgrade_weapon_add("basic_shot","bullet_spread",0.3)
			,
	},
	"upgrade_basic_tri_shot": {
		text = "Tri-Shot: +2 basic shot projectiles, but adds fixed spreaad \n and 2x slower shooting - 30 galactic credits",
		cost = 30,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("basic_shot","bullets_amount",2)
			Globals.player_reference.upgrade_weapon_add("basic_shot","bullet_fixed_spread",0.4)
#decided that normal shot sound is fine
#			Globals.player_reference.upgrade_weapon_set("basic_shot","bullet_sound","res://sound/laser-double.wav")
			Globals.player_reference.upgrade_weapon_mult("basic_shot","firing_rate",2)
			,
	},
	"upgrade_basic_spread": {
		text = "Stabilizer: reduced basic shot spread - 15 galactic credits",
		cost = 15,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("basic_shot","bullet_spread",-0.1)
			,
	},
	"upgrade_basic_spread2": {
		text = "Further reduced basic shot spread - 40 galactic credits",
		required_upgrades = ["upgrade_basic_spread"],
		cost = 40,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("basic_shot","bullet_spread",-0.1)
			,
	},
	"upgrade_basic_homing": {
		text = "Basic shot is now homing - 200 galactic credits",
		required_upgrades = ["upgrade_basic_spread2"],
		cost = 200,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_additionalvar_set("basic_shot","homing","yes")
			Globals.player_reference.upgrade_weapon_additionalvar_set("basic_shot","homing_rotation_speed",3)
			,
	},
	"weapon_shotgun": {
		text = "Shotgun Weapon (num 2 key) - 15 galactic credits",
		cost = 15,
		lambda_func = func(): 
			Globals.weapons_unlocked.append("shotgun")
			Globals.player_reference.equip_weapon("shotgun")
			,
	},
	"upgrade_shotgun_wideshot": {
		text = "1.5x shotgun projectiles per shot, but increased spread - 15 galactic credits",
		cost = 15,
		required_upgrades = ["weapon_shotgun"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","bullets_amount",1.5)
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",0.2)
			,
	},
	"upgrade_shotgun_wideshot2": {
		text = "1.33x shotgun projectiles per shot, but increased spread - 30 galactic credits",
		cost = 30,
		required_upgrades = ["upgrade_shotgun_wideshot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","bullets_amount",1.33)
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",0.2)
			,
	},
	"upgrade_shotgun_wideshot3": {
		text = "1.33x shotgun projectiles per shot, but even more increased spread - 70 galactic credits",
		cost = 70,
		required_upgrades = ["upgrade_shotgun_wideshot2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","bullets_amount",1.33)
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",0.2)
			,
	},
	"upgrade_shotgun_wideshot4": {
		text = "1.33x shotgun projectiles per shot, but even more increased spread - 140 galactic credits",
		cost = 140,
		required_upgrades = ["upgrade_shotgun_wideshot3"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","bullets_amount",1.33)
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",0.25)
			,
	},
	"upgrade_shotgun_wideshot5": {
		text = "1.33x shotgun projectiles per shot, but even more increased spread - 280 galactic credits",
		cost = 280,
		required_upgrades = ["upgrade_shotgun_wideshot4"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","bullets_amount",1.33)
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",0.25)
			,
	},
	"upgrade_shotgun_super": {
		text = "Super Shotgun: 3x damage, 1.5x bullet speed, but 2x slower firing rate - 40 galactic credits",
		cost = 40,
		required_upgrades = ["weapon_shotgun"],
		lambda_func = func():
#			Globals.player_reference.upgrade_weapon_mult("shotgun","bullets_amount",3)
			Globals.player_reference.upgrade_weapon_mult("shotgun","bullet_damage",3)
			Globals.player_reference.upgrade_weapon_mult("shotgun","bullet_speed",1.5)
			Globals.player_reference.upgrade_weapon_mult("shotgun","firing_rate",2)
			,
	},
	"upgrade_shotgun_narrow": {
		text = "Narrower Shotgun spread - 15 galactic credits",
		cost = 15,
		required_upgrades = ["weapon_shotgun"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",-0.2)
			,
	},
	"upgrade_shotgun_narrow2": {
		text = "Even narrower Shotgun spread - 30 galactic credits",
		cost = 30,
		required_upgrades = ["upgrade_shotgun_narrow"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",-0.2)
			,
	},
	"upgrade_shotgun_narrow3": {
		text = "Even narrower Shotgun spread - 60 galactic credits",
		cost = 60,
		required_upgrades = ["upgrade_shotgun_narrow2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",-0.25)
			,
	},
	"upgrade_shotgun_narrow4": {
		text = "Even narrower Shotgun spread - 120 galactic credits",
		cost = 120,
		required_upgrades = ["upgrade_shotgun_narrow3"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",-0.25)
			,
	},
	"upgrade_shotgun_narrow5": {
		text = "Even narrower Shotgun spread - 240 galactic credits",
		cost = 240,
		required_upgrades = ["upgrade_shotgun_narrow4"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("shotgun","bullet_spread",-0.25)
			,
	},
	"upgrade_shotgun_firerate": {
		text = "Shotgun faster firing rate - 20 galactic credits",
		cost = 20,
		required_upgrades = ["weapon_shotgun"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","firing_rate",0.8)
			,
	},
	"upgrade_shotgun_firerate2": {
		text = "Shotgun even faster firing rate - 50 galactic credits",
		cost = 50,
		required_upgrades = ["upgrade_shotgun_firerate"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","firing_rate",0.8)
			,
	},
	"upgrade_shotgun_firerate3": {
		text = "Shotgun even faster firing rate - 100 galactic credits",
		cost = 100,
		required_upgrades = ["upgrade_shotgun_firerate2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("shotgun","firing_rate",0.8)
			,
	},
	"weapon_sniper": {
		text = "Sniper Shot Weapon (num 3 key) - 15 galactic credits",
		cost = 15,
		lambda_func = func(): 
			Globals.weapons_unlocked.append("sniper")
			Globals.player_reference.equip_weapon("sniper")
			,
	},
	"upgrade_sniper_assassin": {
		text = "Assassin: Sniper has 3x damage, but 2x slower firing rate - 45 galactic credits",
		cost = 45,
		required_upgrades = ["upgrade_sniper_damage"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","bullet_damage",3)
#			Globals.player_reference.upgrade_weapon_add("sniper","bullet_spread",-0.2)
			Globals.player_reference.upgrade_weapon_mult("sniper","firing_rate",2)
			,
	},
	"upgrade_sniper_damage": {
		text = "Sniper Shot deals 1.2x more damage - 15 galactic credits",
		cost = 15,
		required_upgrades = ["weapon_sniper"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","bullet_damage",1.2)
			,
	},
	"upgrade_sniper_damage2": {
		text = "Sniper Shot deals 1.25x more damage - 30 galactic credits",
		cost = 30,
		required_upgrades = ["upgrade_sniper_damage"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","bullet_damage",1.25)
			,
	},
	"upgrade_sniper_damage3": {
		text = "Sniper Shot deals 1.25x more damage - 50 galactic credits",
		cost = 50,
		required_upgrades = ["upgrade_sniper_damage2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","bullet_damage",1.25)
			,
	},
	"upgrade_sniper_damage4": {
		text = "Sniper Shot deals 1.25x more damage - 100 galactic credits",
		cost = 100,
		required_upgrades = ["upgrade_sniper_damage3"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","bullet_damage",1.25)
			,
	},
	#1.3 instead of 1.25, to be able to oneshot mk3 basics with assassin upgrade, or mk2 basics without assassin
	"upgrade_sniper_damage5": {
		text = "Sniper Shot deals 1.3x more damage - 200 galactic credits",
		cost = 200,
		required_upgrades = ["upgrade_sniper_damage4"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","bullet_damage",1.3)
			,
	},
	"upgrade_sniper_firerate": {
		text = "Sniper Shot faster firing rate - 20 galactic credits",
		cost = 20,
		required_upgrades = ["weapon_sniper"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","firing_rate",0.8)
			,
	},
	"upgrade_sniper_firerate2": {
		text = "Sniper Shot even faster firing rate - 50 galactic credits",
		cost = 50,
		required_upgrades = ["upgrade_sniper_firerate"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","firing_rate",0.8)
			,
	},
	"upgrade_sniper_noscope": {
		text = "Noscope 360 - much faster firing \n WARNING - MUCH HARDER TO AIM - 15 galactic credits",
		cost = 15,
		required_upgrades = ["weapon_sniper"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("sniper","firing_rate",0.3)
			Globals.player_reference.upgrade_weapon_add("sniper","bullet_spread",1.5)
			,
	},
	"upgrade_sniper_noscope_narrow": {
		text = "Sniper Stabilizer - significantly reduced bullet spread - 30 galactic credits",
		cost = 30,
		required_upgrades = ["upgrade_sniper_noscope"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("sniper","bullet_spread",-0.4)
			,
	},
	"upgrade_sniper_noscope_narrow2": {
		text = "Further reduced Sniper bullet spread - 60 galactic credits",
		cost = 60,
		required_upgrades = ["upgrade_sniper_noscope_narrow"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("sniper","bullet_spread",-0.4)
			,
	},
	"upgrade_sniper_noscope_narrow3": {
		text = "Even further reduced Sniper bullet spread - 110 galactic credits",
		cost = 110,
		required_upgrades = ["upgrade_sniper_noscope_narrow2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_add("sniper","bullet_spread",-0.4)
			,
	},
	#very expensive due to how OP it is
	"upgrade_sniper_homing": {
		text = "Sniper is now homing - 750 galactic credits",
		required_upgrades = ["weapon_sniper"],
		cost = 750,
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_additionalvar_set("sniper","homing","yes")
			Globals.player_reference.upgrade_weapon_additionalvar_set("sniper","homing_rotation_speed",10)
			,
	},
	"weapon_explosive_shot": {
		text = "Explosive Shot Weapon (num 4 key) - 20 galactic credits",
		cost = 20,
		lambda_func = func(): 
			Globals.weapons_unlocked.append("explosive_shot")
			Globals.player_reference.equip_weapon("explosive_shot")
			,
	},
	"explosive_shot_damage1": {
		text = "1.25x damage for explosive shot - 25 galactic credits",
		cost = 25,
		required_upgrades = ["weapon_explosive_shot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","bullet_damage",1.25)
			,
	},
	"explosive_shot_damage2": {
		text = "1.25x damage for explosive shot - 50 galactic credits",
		cost = 50,
		required_upgrades = ["explosive_shot_damage1"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","bullet_damage",1.25)
			,
	},
	"explosive_shot_damage3": {
		text = "1.25x damage for explosive shot - 100 galactic credits",
		cost = 100,
		required_upgrades = ["explosive_shot_damage2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","bullet_damage",1.25)
			,
	},
	"explosive_shot_damage4": {
		text = "1.25x damage for explosive shot - 200 galactic credits",
		cost = 200,
		required_upgrades = ["explosive_shot_damage3"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","bullet_damage",1.25)
			,
	},
	"explosive_shot_blast1": {
		text = "1.25x bigger blast for explosive shot - 40 galactic credits",
		cost = 40,
		required_upgrades = ["explosive_shot_damage1"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_additionalvar_mult("explosive_shot","blast_radius",1.25)
			,
	},
	"explosive_shot_blast2": {
		text = "1.2x bigger blast for explosive shot - 80 galactic credits",
		cost = 80,
		required_upgrades = ["explosive_shot_blast1"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_additionalvar_mult("explosive_shot","blast_radius",1.2)
			,
	},
	"upgrade_explosive_nuke": {
		text = "Nuke: explosive shot has 3x damage, 1.4x blast radius \n but 2x slower firing rate - 40 galactic credits",
		cost = 40,
		required_upgrades = ["weapon_explosive_shot"],
		lambda_func = func():
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","bullet_damage",3)
			Globals.player_reference.upgrade_weapon_additionalvar_mult("explosive_shot","blast_radius",1.4)
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","firing_rate",2)
			,
	},
	"upgrade_explosive_multishot": {
		text = "Explosive Burst: explosive shot has +2 projectiles \n but 2x slower firing rate - 40 galactic credits",
		cost = 40,
		required_upgrades = ["weapon_explosive_shot"],
		lambda_func = func():
			Globals.player_reference.upgrade_weapon_add("explosive_shot","bullets_amount",2)
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","firing_rate",2)
			Globals.player_reference.upgrade_weapon_add("explosive_shot","bullet_spread",0.3)
			,
	},
	#scrapped upgrade. it was simultaneously very strong due to the 2x buff but not very fun due to slow projectiles
	#"upgrade_explosive_mines": {
	#	text = "Space Mines: explosive shot has 2x firing rate \n much slower bullets - 40 galactic credits",
	#	cost = 40,
	#	required_upgrades = ["weapon_explosive_shot"],
	#	lambda_func = func():
	#		Globals.player_reference.upgrade_weapon_mult("explosive_shot","firing_rate",0.5)
	#		Globals.player_reference.upgrade_weapon_mult("explosive_shot","bullet_speed",0.15)
	#		Globals.player_reference.upgrade_weapon_add("explosive_shot","bullet_spread",0.3)
	#		,
	#},
	"upgrade_explosive_firerate": {
		text = "Explosive shot shoots slightly faster - 30 galactic credits",
		cost = 30,
		required_upgrades = ["weapon_explosive_shot"],
		lambda_func = func():
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","firing_rate",0.8)
			,
	},
	"upgrade_explosive_firerate2": {
		text = "Explosive shot shoots slightly faster - 60 galactic credits",
		cost = 60,
		required_upgrades = ["upgrade_explosive_firerate"],
		lambda_func = func():
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","firing_rate",0.8)
			,
	},
	"upgrade_explosive_firerate3": {
		text = "Explosive shot shoots even faster - 120 galactic credits",
		cost = 120,
		required_upgrades = ["upgrade_explosive_firerate2"],
		lambda_func = func():
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","firing_rate",0.8)
			,
	},
	"upgrade_explosive_firerate4": {
		text = "Explosive shot shoots even faster - 240 galactic credits",
		cost = 240,
		required_upgrades = ["upgrade_explosive_firerate3"],
		lambda_func = func():
			Globals.player_reference.upgrade_weapon_mult("explosive_shot","firing_rate",0.8)
			,
	},
	"weapon_spin_shot": {
		text = "Spin Shot Weapon (num 5 key) - 50 galactic credits",
		cost = 50,
		lambda_func = func(): 
			Globals.weapons_unlocked.append("spin_shot")
			Globals.player_reference.equip_weapon("spin_shot")
			,
	},
	#TODO: make the next two upgrades mutually exclusive:
	"upgrade_spin_rapid_spin": {
		text = "Rapid Spin - Spin Shot fires 5x faster \n but has much 3x fewer projectiles - 30 galactic credits",
		cost = 30,
		required_upgrades = ["weapon_spin_shot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","firing_rate",0.2)
			Globals.player_reference.upgrade_weapon_mult("spin_shot","bullets_amount",0.33)
			,
	},
	"upgrade_spin_mega_spin": {
		text = "Mega Spin - Spin Shot has 2x projectiles \n but fires 1.5x slower - 40 galactic credits",
		cost = 40,
		required_upgrades = ["weapon_spin_shot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","firing_rate",1.5)
			Globals.player_reference.upgrade_weapon_mult("spin_shot","bullets_amount",2)
			,
	},
	"upgrade_spin_shot_damage": {
		text = "Spin Shot deals 1.5x damage - 80 galactic credits",
		cost = 80,
		required_upgrades = ["weapon_spin_shot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","bullet_damage",1.5)
			,
	},
	"upgrade_spin_shot_projectiles": {
		text = "Spin Shot has 1.25x more projectiles - 30 galactic credits",
		cost = 30,
		required_upgrades = ["weapon_spin_shot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","bullets_amount",1.25)
			,
	},
	"upgrade_spin_shot_projectiles2": {
		text = "Spin Shot has 1.25x more projectiles - 80 galactic credits",
		cost = 80,
		required_upgrades = ["upgrade_spin_shot_projectiles"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","bullets_amount",1.25)
			,
	},
	"upgrade_spin_shot_projectiles3": {
		text = "Spin Shot has 1.25x more projectiles - 160 galactic credits",
		cost = 160,
		required_upgrades = ["upgrade_spin_shot_projectiles2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","bullets_amount",1.25)
			,
	},
	"upgrade_spin_firingrate": {
		text = "Spin Shot shoots slightly faster - 30 galactic credits",
		cost = 30,
		required_upgrades = ["weapon_spin_shot"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","firing_rate",0.8)
			,
	},
	"upgrade_spin_firingrate2": {
		text = "Spin Shot shoots even faster - 70 galactic credits",
		cost = 70,
		required_upgrades = ["upgrade_spin_firingrate"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","firing_rate",0.8)
			,
	},
	"upgrade_spin_firingrate3": {
		text = "Spin Shot shoots even faster - 140 galactic credits",
		cost = 140,
		required_upgrades = ["upgrade_spin_firingrate2"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","firing_rate",0.8)
			,
	},
	"upgrade_spin_firingrate4": {
		text = "Spin Shot shoots even faster - 280 galactic credits",
		cost = 280,
		required_upgrades = ["upgrade_spin_firingrate3"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("spin_shot","firing_rate",0.8)
			,
	},
	"weapon_minigun": {
		text = "Minigun Weapon (num 6 key) - 250 galactic credits",
		cost = 250,
		lambda_func = func(): 
			Globals.weapons_unlocked.append("minigun")
			Globals.player_reference.equip_weapon("minigun")
			,
	},
	"upgrade_minigun_damage": {
		text = "Minigun deals 1.5x damage - 200 galactic credits",
		cost = 200,
		required_upgrades = ["weapon_minigun"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("minigun","bullet_damage",1.5)
			,
	},
	"upgrade_minigun_narrow": {
		text = "Reduced minigun bullet spread, increased bullet speed - 100 galactic credits",
		cost = 100,
		required_upgrades = ["weapon_minigun"],
		lambda_func = func(): 
			Globals.player_reference.upgrade_weapon_mult("minigun","bullet_speed",1.5)
			Globals.player_reference.upgrade_weapon_add("minigun","bullet_spread",-0.2)
			,
	},
	"ability_overclock": {
		text = "Overclock Ability (X key)
Temporarily increases firing speed by 2x for 5 seconds
Has a 20-second cooldown after the duration ends
Resets current weapon cooldown
	50 galactic credits",
		cost = 50,
		lambda_func = func(): 
			Globals.abilities_unlocked.append("overclock")
			Globals.player_reference.overclock_duration = 5
			Globals.player_reference.overclock_cooldown_max = 20
			Globals.player_reference.overclock_firerate_mult = 0.5
			,
	},
	"upgrade_overclock_power": {
		text = "Overclock has 3x firing speed boost instead of 2x - 100 galactic credits",
		cost = 100,
		required_upgrades = ["ability_overclock"],
		lambda_func = func(): 
			Globals.player_reference.overclock_firerate_mult = 0.33
			,
	},
	"upgrade_overclock_duration": {
		text = "Overclock lasts 1.5x as long - 80 galactic credits",
		cost = 80,
		required_upgrades = ["ability_overclock"],
		lambda_func = func(): 
			Globals.player_reference.overclock_duration *= 1.5
			,
	},
	"upgrade_overclock_cooldown": {
		text = "Overclock has 2/3 cooldown - 75 galactic credits",
		cost = 75,
		required_upgrades = ["ability_overclock"],
		lambda_func = func(): 
			Globals.player_reference.overclock_cooldown_max = (Globals.player_reference.overclock_cooldown_max * 2) / 3
			#reset cooldown:
			Globals.player_reference.overclock_cooldown = 0
			,
	},
	"ability_shield": {
		text = "Deflector Shield Ability (C key)
Creates a shield around the player, deflecting enemy shots
Deflected shots become blue and damage enemies
Shield Lasts 5 seconds
Has a 30-second cooldown after the duration ends
	50 galactic credits",
		cost = 50,
		lambda_func = func(): 
			Globals.abilities_unlocked.append("shield")
			Globals.player_reference.shield_duration = 5.0
			Globals.player_reference.shield_cooldown_max = 30.0
			Globals.player_reference.shield_scale = 3
			,
	},
	"upgrade_shield_parry": {
		text = "Deflector Parry: shield cooldown is 10x faster
But the shield duration is 10x shorter too - 80 galactic credits",
		required_upgrades = ["ability_shield"],
		cost = 80,
		lambda_func = func(): 
			Globals.player_reference.shield_duration = Globals.player_reference.shield_duration / 10
			Globals.player_reference.shield_cooldown_max = Globals.player_reference.shield_cooldown_max / 10
			#reset cooldown:
			Globals.player_reference.shield_cooldown = 0
			,
	},
	"upgrade_shield_duration": {
		text = "1.5x Shield Duration, 75 galactic credits",
		required_upgrades = ["ability_shield"],
		cost = 75,
		lambda_func = func(): 
			Globals.player_reference.shield_duration = Globals.player_reference.shield_duration * 1.5
			,
	},
	"upgrade_shield_radius": {
		text = "1.5x Shield Radius, 100 galactic credits",
		required_upgrades = ["ability_shield"],
		cost = 100,
		lambda_func = func(): 
			Globals.player_reference.shield_scale = Globals.player_reference.shield_scale * 1.5
			,
	},
	"ability_drone": {
		text = "Deploy Drone Ability (Z key)
Summons a drone ally, which shoots at enemies
Drone can be destroyed by enemy attacks
Has a 20-second cooldown
Can only have 1 drones active at a time
Going above the drone limit self-destructs a previous drone
	25 galactic credits",
		cost = 25,
		lambda_func = func():
			Globals.abilities_unlocked.append("drone")
			Globals.player_reference.drone_cooldown_max = 20.0
			Globals.player_reference.drone_hp = 100
			Globals.player_reference.drone_firingrate = 0.3
			Globals.player_reference.drone_bulletspread = 0.1			
			Globals.player_reference.drone_limit = 1
			,
	},
	"upgrade_drone_hp": {
		text = "Drones have 2x as much HP, 60 galactic credits
(only applies to new drones, not existing ones)",
		required_upgrades = ["ability_drone"],
		cost = 60,
		lambda_func = func(): 
			Globals.player_reference.drone_hp = Globals.player_reference.drone_hp * 2
			,
	},
	"upgrade_drone_hp2": {
		text = "Drones have 1.5x as much HP, 90 galactic credits
(only applies to new drones, not existing ones)",
		required_upgrades = ["upgrade_drone_hp"],
		cost = 90,
		lambda_func = func(): 
			Globals.player_reference.drone_hp = Globals.player_reference.drone_hp * 1.5
			,
	},
	"upgrade_drone_firerate": {
		text = "Drones shoot 2x faster, 75 galactic credits
(only applies to new drones, not existing ones)",
		required_upgrades = ["ability_drone"],
		cost = 60,
		lambda_func = func(): 
			Globals.player_reference.drone_firingrate = Globals.player_reference.drone_firingrate / 2
			,
	},
	"upgrade_drone_firerate2": {
		text = "Drones shoot 2x faster but have more bullet spread, 90 galactic credits
(only applies to new drones, not existing ones)",
		required_upgrades = ["upgrade_drone_firerate"],
		cost = 90,
		lambda_func = func(): 
			Globals.player_reference.drone_firingrate = Globals.player_reference.drone_firingrate / 2
			Globals.player_reference.drone_bulletspread += 0.2
			,
	},
	"upgrade_drone_rotate": {
		text = "Drone Targeting System: 
Drone now rotates to shoot at enemies - 125 galactic credits
(only applies to new drones, not existing ones)",
		cost = 125,
		required_upgrades = ["ability_drone"],
		lambda_func = func(): 
			Globals.player_reference.drone_can_rotate = true
			,
	},
	"upgrade_drone_shield": {
		text = "Shielded Drones: 
Drone now have an automatic shield for 3 seconds
with a 9 second cooldown - 100 galactic credits
(only applies to new drones, not existing ones)",
		cost = 100,
		required_upgrades = ["ability_drone","ability_shield"],
		lambda_func = func(): 
			Globals.player_reference.drone_additional_vars = {
			has_shield = true,
			shield_duration = 3,
			shield_cooldown_max = 9,
			shield_scale = 2.5,
		}	,
	},	
	"upgrade_drone_cooldown": {
		text = "Deploy Drone has 2/3 cooldown - 75 galactic credits",
		cost = 75,
		required_upgrades = ["ability_drone"],
		lambda_func = func(): 
			Globals.player_reference.drone_cooldown_max = (Globals.player_reference.drone_cooldown_max * 2) / 3
			#reset cooldown:
			Globals.player_reference.drone_cooldown = 0
			,
	},
	"upgrade_drone_limit": {
		text = "Can have up to 2 drones at a time - 75 galactic credits",
		cost = 75,
		required_upgrades = ["ability_drone"],
		lambda_func = func(): 
			Globals.player_reference.drone_limit += 1
			,
	},
	"upgrade_drone_limit2": {
		text = "Can have up to 3 drones at a time - 125 galactic credits",
		cost = 125,
		required_upgrades = ["upgrade_drone_limit"],
		lambda_func = func(): 
			Globals.player_reference.drone_limit += 1
			,
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.upgrademenu_reference = $"."
	load_options()

func load_options():
	for removed_button in $MarginContainer/ScrollContainer/VBoxContainer.get_children():
		removed_button.queue_free()
	
	for current_button in upgrade_buttons:
		var requirements_match = true
		#if the required_upgrades key exists, check all requirements, and if at least one requirement does not match, hide the upgrade:
		if upgrade_buttons[current_button].keys().find("required_upgrades") != -1:
#			print("found upgrade with requirements")
			for current_requirement in upgrade_buttons[current_button]["required_upgrades"]:
				if Globals.upgrades_taken.find(current_requirement) == -1:
					requirements_match = false
		#only create upgrade button if upgrade is not taken:
		if Globals.upgrades_taken.find(current_button) == -1 and requirements_match == true:
#			print(upgrade_buttons[current_button]["text"])
			var new_button = button_upgrade.instantiate()
			new_button.id = current_button
			new_button.text = upgrade_buttons[current_button]["text"]
			new_button.cost = upgrade_buttons[current_button]["cost"]
			new_button.lambda_func = upgrade_buttons[current_button]["lambda_func"]
			$MarginContainer/ScrollContainer/VBoxContainer.add_child(new_button)

#quit button
func _on_button_pressed():
	Globals.upgrade_pause = false
	get_tree().paused = false
	queue_free()
