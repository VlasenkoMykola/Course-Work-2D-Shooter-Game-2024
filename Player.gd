extends CharacterBody2D


var SPEED = 300.0
var attack_cooldown = 0

#default weapon data is intentionally left empty, since it is changed when you equip a weapon anyway

@export var Bullet : PackedScene
#spread = 3.1 is roughly 360 degree shooting
@export var bullet_spread = 0#0.1
@export var bullets_amount = 0#1
@export var firing_rate = 0#0.2
#stacks with random spread, works best with at least 2 bullets at once
#fixed spread = 6.2 is roughly 360 degree shooting
@export var bullet_fixed_spread = 0.0
@export var bullet_damage = 0.0#10
@export var bullet_speed = 0#-700
@export var bullet_sound = "res://sound/laser-small.wav"
@export var MaxHP = 100.0
@export var regen_rate = 3.0
var movement_speedmult = 1
var HP = 0
var equipped_weapon_name
var additional_weapon_vars = {}
var overclock_time_left = 0
var overclock_duration = 0
var overclock_cooldown = 0
var overclock_cooldown_max = 0
var overclock_firerate_mult = 0
var DeflectorShield = preload("res://deflector_shield_player.tscn")
var shield_cooldown = 0
var shield_cooldown_max = 0
var shield_duration = 0
var shield_scale = 0
var drone_cooldown = 0
var drone_cooldown_max = 0
var drone_hp = 0
var drone_firingrate = 0
var drone_bulletspread = 0
var drone_can_rotate = false
var drone_additional_vars = {}
var drone_limit = 0
#used for drone summon:
var Enemy = preload("res://enemy.tscn")


#dictionary inside a dictionary
var weapons : Dictionary = {
	"basic_shot": {
		Bullet = "res://player_bullet.tscn",
		bullet_spread = 0.1,
		bullets_amount = 1,
		firing_rate = 0.2,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -700,
		bullet_sound = "res://sound/laser-small.wav",
		movement_speedmult = 1,
		additional_weapon_vars = {},
	},
	"shotgun": {
		Bullet = "res://player_bullet.tscn",
		bullet_spread = 0.5,
		bullets_amount = 7,
		firing_rate = 1,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -700,
		bullet_sound = "res://sound/laser-double.wav",
		movement_speedmult = 1,
		additional_weapon_vars = {},
	},
	"sniper": {
		Bullet = "res://player_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 1,
		firing_rate = 1,
		bullet_fixed_spread = 0.0,
		bullet_damage = 50,
		bullet_speed = -2000,
		bullet_sound = "res://sound/laser-beam.wav",
		movement_speedmult = 1,
		additional_weapon_vars = {},
	},
	"explosive_shot": {
#		Bullet = "res://player_bullet.tscn",
		Bullet = "res://player_bullet_explosive.tscn",
		bullet_spread = 0.1,
		bullets_amount = 1,
		firing_rate = 1.5,
		bullet_fixed_spread = 0.0,
		bullet_damage = 25,
		bullet_speed = -800,
		bullet_sound = "res://sound/laser-double.wav",
		movement_speedmult = 1,
		additional_weapon_vars = {
			blast_radius = 8,			
		},
	},
	"flanker": {
		Bullet = "res://player_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 3,
		firing_rate = 0.3,
		bullet_fixed_spread = 6.2,
		bullet_damage = 10,
		bullet_speed = -700,
		bullet_sound = "res://sound/laser-small.wav",
		movement_speedmult = 1.2,
		additional_weapon_vars = {},
	},
	"spin_shot": {
		Bullet = "res://player_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 50,
		firing_rate = 3,
		bullet_fixed_spread = 6.2,
		bullet_damage = 10,
		bullet_speed = -700,
		bullet_sound = "res://sound/laser-wobble.wav",
		movement_speedmult = 1,
		additional_weapon_vars = {},
	},
	#half damage/movespeed, insane firing rate
	"minigun": {
		Bullet = "res://player_bullet.tscn",
		bullet_spread = 0.5,
		bullets_amount = 1,
		firing_rate = 0.01,
		bullet_fixed_spread = 0.0,
		bullet_damage = 5,
		bullet_speed = -700,
		bullet_sound = "res://sound/laser-small.wav",
		movement_speedmult = 0.5,
		additional_weapon_vars = {},
	},
}

func equip_weapon(weapon_name):
	equipped_weapon_name = weapon_name
	var current_weapon = weapons[weapon_name]
	Bullet = load(current_weapon["Bullet"])
	bullet_spread = current_weapon["bullet_spread"]
	bullets_amount = current_weapon["bullets_amount"]
	firing_rate = current_weapon["firing_rate"]
	bullet_fixed_spread = current_weapon["bullet_fixed_spread"]
	bullet_damage = current_weapon["bullet_damage"]
	bullet_speed = current_weapon["bullet_speed"]
	bullet_sound = current_weapon["bullet_sound"]	
	movement_speedmult = current_weapon["movement_speedmult"]
	additional_weapon_vars = current_weapon["additional_weapon_vars"]
	#loads bullet sound
	$ShootSound.stream = load(bullet_sound) 

func upgrade_weapon_add(weapon_name,value_to_upgrade,add):
	weapons[weapon_name][value_to_upgrade] += add
	equip_weapon(weapon_name)

func upgrade_weapon_mult(weapon_name,value_to_upgrade,mult):
	weapons[weapon_name][value_to_upgrade] = weapons[weapon_name][value_to_upgrade] * mult
	equip_weapon(weapon_name)

#for stuff like "replace projectile":

func upgrade_weapon_set(weapon_name,value_to_upgrade,value):
	weapons[weapon_name][value_to_upgrade] = value
	equip_weapon(weapon_name)

func upgrade_weapon_additionalvar_add(weapon_name,value_to_upgrade,add):
	weapons[weapon_name]["additional_weapon_vars"][value_to_upgrade] += add
	equip_weapon(weapon_name)

func upgrade_weapon_additionalvar_mult(weapon_name,value_to_upgrade,mult):
	weapons[weapon_name]["additional_weapon_vars"][value_to_upgrade] = weapons[weapon_name]["additional_weapon_vars"][value_to_upgrade] * mult
	equip_weapon(weapon_name)

#for stuff like "replace projectile":

func upgrade_weapon_additionalvar_set(weapon_name,value_to_upgrade,value):
	weapons[weapon_name]["additional_weapon_vars"][value_to_upgrade] = value
	equip_weapon(weapon_name)


func _ready():
	Globals.player_reference = $"."
	HP = MaxHP
	equip_weapon("basic_shot")
#commented out, it was used for testing
#	upgrade_weapon_add("shotgun","bullets_amount",5)
#	upgrade_weapon_mult("shotgun","firing_rate",0.3)
#	upgrade_weapon_mult("basic_shot","bullets_amount",3)
#	upgrade_weapon_mult("basic_shot","firing_rate",2)
#	upgrade_weapon_add("basic_shot","bullet_spread",0.1)

func _input(event):
	#use number keys to swap weapons:
	
#	print(event.as_text())
	if event.as_text() == "1" and Globals.weapons_unlocked.find("basic_shot") != -1:
		equip_weapon("basic_shot")
	if event.as_text() == "2"  and Globals.weapons_unlocked.find("shotgun") != -1:
		equip_weapon("shotgun")
	if event.as_text() == "3" and Globals.weapons_unlocked.find("sniper") != -1:
		equip_weapon("sniper")
	if event.as_text() == "4" and Globals.weapons_unlocked.find("explosive_shot") != -1:
		equip_weapon("explosive_shot")
#	if event.as_text() == "4" and Globals.weapons_unlocked.find("flanker") != -1:
#		equip_weapon("flanker")
	if event.as_text() == "5" and Globals.weapons_unlocked.find("spin_shot") != -1:
		equip_weapon("spin_shot")
	if event.as_text() == "6" and Globals.weapons_unlocked.find("minigun") != -1:
		equip_weapon("minigun")
	if event.as_text() == "Shift" and Globals.upgrade_pause == false:
		var upgrademenu = load("res://upgrade_ui.tscn")
#		print("upgrade menu opened")
		var menu = upgrademenu.instantiate()
		get_tree().get_root().add_child(menu)		
		Globals.upgrade_pause = true
		get_tree().paused = true
	#overclock ability:
	if event.as_text() == "X" and overclock_cooldown <= 0 and Globals.abilities_unlocked.find("overclock") != -1:
		overclock_time_left = overclock_duration
		#this way, cooldown basically starts AFTER duration ends
		overclock_cooldown = overclock_duration + overclock_cooldown_max
		attack_cooldown = 0
		$AbilitySound.stream = load("res://sound/mixkit-sci-fi-construction-complete-811.ogg")
		$AbilitySound.play()
	if event.as_text() == "C" and shield_cooldown <= 0 and Globals.abilities_unlocked.find("shield") != -1:
		var shield = DeflectorShield.instantiate()
		shield.duration_left = shield_duration
		shield.scale_var = Vector2(shield_scale,shield_scale)
#shield moves with the player:
		self.add_child(shield)
		#this way, cooldown basically starts AFTER duration ends
		shield_cooldown = shield_duration + shield_cooldown_max
		$AbilitySound.stream = load("res://sound/shield.ogg")
		$AbilitySound.play()
	if event.as_text() == "Z" and drone_cooldown <= 0 and Globals.abilities_unlocked.find("drone") != -1:

		var all_drones = get_tree().get_nodes_in_group("Player_Drones")
		
		#if exceeding drone limit, self destruct oldest existing drone
		if all_drones.size() >= drone_limit:
			all_drones[0].damage(99999)

		var e = Enemy.instantiate()
		e.set_enemy_type("playersummon_drone")
		e.position = self.position
		get_tree().get_root().add_child(e)
		e.convert_to_ally()
		e.add_to_group("Player_Drones")#for drone limit
		e.MaxHP = drone_hp
		e.HP = e.MaxHP
		e.firing_rate = drone_firingrate
		e.bullet_spread = drone_bulletspread
		e.can_rotate = drone_can_rotate
		e.additional_vars = drone_additional_vars
		drone_cooldown = drone_cooldown_max


func _physics_process(delta): 
	
	attack_cooldown -= delta
	HP += regen_rate * delta
	if HP > MaxHP:
		HP = MaxHP
	$HealthDisplay.update_healthbar(HP)
	
	overclock_time_left -= delta
	overclock_cooldown -= delta
	shield_cooldown -= delta
	drone_cooldown -= delta
	
	# shoot projectile
	if Input.is_action_pressed("ui_accept") and attack_cooldown <= 0:
		shoot()
		attack_cooldown = firing_rate
		if overclock_time_left > 0:
			attack_cooldown = attack_cooldown * overclock_firerate_mult

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.x = direction * SPEED * movement_speedmult
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction_y:
		velocity.y = direction_y * SPEED * movement_speedmult
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func shoot():

	$ShootSound.play()

	var rng = RandomNumberGenerator.new()
	
	var bullets_left = bullets_amount
	
	var fixedspread_value = 0
	var fixedspread_step = 0

	if bullets_amount > 1:
		fixedspread_value = -bullet_fixed_spread / 2
		fixedspread_step = bullet_fixed_spread / (bullets_amount -  1)#subtracting one to prevent offset
	
	while bullets_left > 0:
		bullets_left -= 1
		var b = Bullet.instantiate()
		b.transform = $Marker2D.global_transform
		b.damage = bullet_damage
		b.speed = bullet_speed
		if additional_weapon_vars.keys().find("blast_radius") != -1:
			b.set_explosion_size(additional_weapon_vars["blast_radius"])
		if additional_weapon_vars.keys().find("homing") != -1:
			b.homing = true
		if additional_weapon_vars.keys().find("homing_rotation_speed") != -1:
			b.rotation_speed = additional_weapon_vars["homing_rotation_speed"]
		get_tree().get_root().add_child(b)
			
		#negative bullet spread is ignored:
		if bullet_spread > 0:
			b.rotation += rng.randf_range(-bullet_spread,bullet_spread)#random float spreaad
		b.rotation += fixedspread_value
		fixedspread_value += fixedspread_step
#		print(b.rotation)
	
func damage(num):
	HP -= num
	$HurtSound.play()
	#player damage flash is more intense than enemy damage flash, since it will happen more rarely
	$AnimatedSprite2D.modulate = Color(5,5,5)
	var tween = get_tree().create_tween()
	#reset color to normal
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1), 0.4)
	$HealthDisplay.update_healthbar(HP)
	if HP <= 0:
		#clear all enemies on screen
		get_tree().call_group("Enemies","queue_free")
		get_tree().call_group("Player_Allies","queue_free")
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
		Globals.reset_globals()
