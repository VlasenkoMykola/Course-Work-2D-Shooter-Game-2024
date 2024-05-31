extends CharacterBody2D

@export var this_enemy_type = "basic"
@export var Bullet : PackedScene
#spread = 3.1 is roughly 360 degree shooting
@export var bullet_spread = 0.1
@export var bullets_amount = 1
@export var firing_rate = 2.5
#to make enemies fire not at the same time, add a value betwee -rand and rand:
#Note: for faster-firing enemies, set this value to 0
@export var firing_rate_rand = 0.25
#stacks with random spread, works best with at least 2 bullets at once
#fixed spread = 6.2 is roughly 360 degree shooting
@export var bullet_fixed_spread = 0.0
@export var bullet_damage = 10
@export var bullet_speed = -200
@export var bullet_sound = "res://sound/laser-small.wav"
@export var MaxHP = 50.0
@export var SPEED = 100.0
@export var drop_currency = 0
@export var can_rotate = false
@export var additional_vars = {}

#this variable is disabled for summoner enemies to avoid money farming

var can_drop_money = true

#reference to basic enemy itself, for summoning purposes
var summon_reference = preload("res://enemy.tscn")

var HP = 0
var rng = RandomNumberGenerator.new()
var attack_cooldown = 0
var summon_cooldown = 0
var shield_cooldown = 0
var direction_x = 1

var Explosion = preload("res://explosion.tscn")
#to prevent multiple explosions spawning if enemy is killed by multiple shots at once
var death_code_triggered = false

var DeflectorShield = preload("res://deflector_shield_enemy.tscn")

#non-hardcoded enemy types:

#dictionary inside a dictionary
var enemy_types : Dictionary = {
	"basic": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlack1.png",
		scale = 1.0,
		MaxHP = 50.0,
		SPEED = 100,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.1,
		bullets_amount = 1,
		firing_rate = 2.5,
		firing_rate_rand = 0.25,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -200,
		bullet_sound = "res://sound/laser-small.wav",
		drop_currency = 5,
		additional_vars = {},
	},
	"shotgun": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlack2.png",
		scale = 2.0,
		MaxHP = 250.0,
		SPEED = 80,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.6,
		bullets_amount = 15,
		firing_rate = 2.5,
		firing_rate_rand = 0.25,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -200,
		bullet_sound = "res://sound/laser-double.wav",
		drop_currency = 25,
		additional_vars = {},
	},
	"machinegun": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlack3.png",
		scale = 2.0,
		MaxHP = 250.0,
		SPEED = 100,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.4,
		bullets_amount = 1,
		firing_rate = 0.4,
		firing_rate_rand = 0.05,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -200,
		bullet_sound = "res://sound/laser-small-quiet.wav",
		drop_currency = 25,
		additional_vars = {},
	},
	"sniper": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlack5.png",
		scale = 2.0,
		MaxHP = 250.0,
		SPEED = 100,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 1,
		firing_rate = 2,
		firing_rate_rand = 0.1,
		bullet_fixed_spread = 0.0,
		bullet_damage = 40,
		bullet_speed = -500,
		bullet_sound = "res://sound/laser-beam.wav",
		drop_currency = 25,
		can_rotate = true,
		additional_vars = {},
	},
	"carrier": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlack4.png",
		scale = 2.5,
		MaxHP = 400.0,
		SPEED = 70,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.1,
		bullets_amount = 1,
		firing_rate = 2.5,
		firing_rate_rand = 0.25,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -200,
		bullet_sound = "res://sound/laser-small.wav",
		#summoned enemies do not drop cash, so the base drop is slightly higher
		drop_currency = 40,
		additional_vars = {
			summon_enemy_type = "basic",
			summon_enemy_rate = 7,
		},
	},
	"basic_mk2": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlue1.png",
		scale = 1.2,
		MaxHP = 150.0,
		SPEED = 120,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.2,
		bullets_amount = 3,
		firing_rate = 2,
		firing_rate_rand = 0.2,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-small.wav",
		drop_currency = 10,
		additional_vars = {},
	},
	"shotgun_mk2": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlue2.png",
		scale = 2.4,
		MaxHP = 750.0,
		SPEED = 100,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 1,
		bullets_amount = 30,
		firing_rate = 2,
		firing_rate_rand = 0.2,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-double.wav",
		drop_currency = 50,
		additional_vars = {},
	},
	"machinegun_mk2": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlue3.png",
		scale = 2.4,
		MaxHP = 750.0,
		SPEED = 100,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.5,
		bullets_amount = 1,
		firing_rate = 0.25,
		firing_rate_rand = 0.05,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-small-quiet.wav",
		drop_currency = 50,
		additional_vars = {},
	},
	"sniper_mk2": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlue5.png",
		scale = 2.4,
		MaxHP = 750.0,
		SPEED = 120,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 1,
		firing_rate = 1.8,
		firing_rate_rand = 0.1,
		bullet_fixed_spread = 0.0,
		bullet_damage = 60,
		bullet_speed = -650,
		bullet_sound = "res://sound/laser-beam.wav",
		drop_currency = 50,
		can_rotate = true,
		additional_vars = {},
	},
	"carrier_mk2": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyBlue4.png",
		scale = 3,
		MaxHP = 900.0,
		SPEED = 70,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.2,
		bullets_amount = 3,
		firing_rate = 2,
		firing_rate_rand = 0.2,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-small.wav",
		#summoned enemies do not drop cash, so the base drop is slightly higher
		drop_currency = 80,
		additional_vars = {
			summon_enemy_type = "basic_mk2",
			summon_enemy_rate = 6.5,
		},
	},
	"basic_mk3": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyDark1.png",
		scale = 1.4,
		MaxHP = 450.0,
		SPEED = 140,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.2,
		bullets_amount = 3,
		firing_rate = 1.5,
		firing_rate_rand = 0.2,
		bullet_fixed_spread = 0.0,
		bullet_damage = 15,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-small.wav",
		drop_currency = 20,
		additional_vars = {},
	},
	"shotgun_mk3": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyDark2.png",
		scale = 2.8,
		MaxHP = 2250.0,
		SPEED = 100,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 1.4,
		bullets_amount = 45,
		firing_rate = 1.5,
		firing_rate_rand = 0.1,
		bullet_fixed_spread = 0.0,
		bullet_damage = 15,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-double.wav",
		drop_currency = 100,
		additional_vars = {},
	},
	"machinegun_mk3": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyDark3.png",
		scale = 2.8,
		MaxHP = 2250.0,
		SPEED = 100,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.5,
		bullets_amount = 1,
		firing_rate = 0.2,
		firing_rate_rand = 0.025,
		bullet_fixed_spread = 0.0,
		bullet_damage = 15,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-small-quiet.wav",
		drop_currency = 100,
		can_rotate = true,
		additional_vars = {},
	},
	"sniper_mk3": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyDark5.png",
		scale = 2.8,
		MaxHP = 2250.0,
		SPEED = 140,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 1,
		firing_rate = 1.5,
		firing_rate_rand = 0.05,
		bullet_fixed_spread = 0.0,
		bullet_damage = 80,
		bullet_speed = -750,
		bullet_sound = "res://sound/laser-beam.wav",
		drop_currency = 50,
		can_rotate = true,
		additional_vars = {},
	},
	"carrier_mk3": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyDark4.png",
		scale = 3.5,
		MaxHP = 2700.0,
		SPEED = 70,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.4,
		bullets_amount = 5,
		firing_rate = 1.5,
		firing_rate_rand = 0.2,
		bullet_fixed_spread = 0.0,
		bullet_damage = 15,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-small.wav",
		#summoned enemies do not drop cash, so the base drop is slightly higher
		drop_currency = 160,
		additional_vars = {
			summon_enemy_type = "basic_mk3",
			summon_enemy_rate = 6,
		},
	},
	"boss_shotgun": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyRed2.png",
		scale = 4.0,
		MaxHP = 1200.0,
		SPEED = 50,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 1.5,
		bullets_amount = 30,
		firing_rate = 1,
		firing_rate_rand = 0,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -200,
		bullet_sound = "res://sound/laser-double.wav",
		drop_currency = 75,
		additional_vars = {},
	},
	"boss_multiphase1": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyRed1.png",
		scale = 4.0,
		MaxHP = 1800.0,
		SPEED = 60,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.5,
		bullets_amount = 1,
		firing_rate = 0.15,
		firing_rate_rand = 0,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -200,
		bullet_sound = "res://sound/laser-small.wav",
		drop_currency = 100,
		additional_vars = {
			is_multiphase = true,
			multiphase_type = "boss_multiphase2",
			multiphase_threshold = 0.5,
		},
	},
	"boss_multiphase2": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyRed1.png",
		scale = 4.0,
		MaxHP = 1800.0,
		SPEED = 50,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 3,
		firing_rate = 0.25,
		firing_rate_rand = 0,
		bullet_fixed_spread = 1.0,
		bullet_damage = 10,
		bullet_speed = -200,
		bullet_sound = "res://sound/laser-double.wav",
		drop_currency = 100,
		can_rotate = true,
		additional_vars = {},
	},
	"boss_sniper": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyRed5.png",
		scale = 3.0,
		MaxHP = 2200.0,
		SPEED = 500,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0,
		bullets_amount = 1,
		firing_rate = 1,
		firing_rate_rand = 0.1,
		bullet_fixed_spread = 0.0,
		bullet_damage = 60,
		bullet_speed = -700,
		bullet_sound = "res://sound/laser-beam.wav",
		drop_currency = 125,
		can_rotate = true,
		additional_vars = {},
	},
	"boss_machinegun": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyRed3.png",
		scale = 6.0,
		MaxHP = 5000.0,
		SPEED = 30,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 3.1,
		bullets_amount = 12,
		firing_rate = 0.35,
		firing_rate_rand = 0,
		bullet_fixed_spread = 0.0,
		bullet_damage = 15,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-double.wav",
		drop_currency = 200,
		additional_vars = {},
	},
	"boss_carrier": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyRed4.png",
		scale = 6.0,
		MaxHP = 20000.0,
		SPEED = 60,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.0,
		bullets_amount = 7,
		firing_rate = 1,
		firing_rate_rand = 0.0,
		bullet_fixed_spread = 0.8,
		bullet_damage = 20,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-double.wav",
		#summoned enemies do not drop cash, so the base drop is slightly higher
		drop_currency = 500,
		can_rotate = true,
		additional_vars = {
			summon_enemy_type = "carrier_mk3",
			summon_enemy_rate = 10,
		},
	},	
	"boss_shotgun_elite": {
		sprite = "res://kenney_space-shooter-redux/PNG/Enemies/enemyDarkRed2.png",
		scale = 6.0,
		MaxHP = 25000.0,
		SPEED = 50,
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 1.5,
		bullets_amount = 45,
		firing_rate = 1,
		firing_rate_rand = 0,
		bullet_fixed_spread = 0.0,
		bullet_damage = 20,
		bullet_speed = -250,
		bullet_sound = "res://sound/laser-double.wav",
		drop_currency = 500,
		can_rotate = true,
		additional_vars = {
			has_shield = true,
			shield_duration = 7.5,
			shield_cooldown_max = 15,
			shield_scale = 1,		
		},
	},
	#note: MaxHP, firing rate bullet spread and additional vars variables get overwritten by player variables during spawn
	"playersummon_drone": {
		sprite = "res://kenney_space-shooter-redux/PNG/ufoBlue.png",
		scale = 0.8,
		MaxHP = 100.0,
		SPEED = 120,
		#this gets automatically replaced by the convert_to_ally function:
		Bullet = "res://enemy_bullet.tscn",
		bullet_spread = 0.1,
		bullets_amount = 1,
		firing_rate = 0.3,
		firing_rate_rand = 0,
		bullet_fixed_spread = 0.0,
		bullet_damage = 10,
		bullet_speed = -700,
		bullet_sound = "res://sound/laser-small-quiet.wav",
		drop_currency = 0,
		additional_vars = {},
	},
}

func set_enemy_type(enemy_type):
	this_enemy_type = enemy_type
	var current_enemy_type = enemy_types[enemy_type]
	Bullet = load(current_enemy_type["Bullet"])
	MaxHP = current_enemy_type["MaxHP"]
	HP = MaxHP
	SPEED = current_enemy_type["SPEED"]
	$Sprite2D.texture = load(current_enemy_type["sprite"])
	scale.x = current_enemy_type["scale"]
	scale.y = current_enemy_type["scale"]
	bullet_spread = current_enemy_type["bullet_spread"]
	bullets_amount = current_enemy_type["bullets_amount"]
	firing_rate = current_enemy_type["firing_rate"]
	bullet_fixed_spread = current_enemy_type["bullet_fixed_spread"]
	firing_rate_rand = current_enemy_type["firing_rate_rand"]
	bullet_damage = current_enemy_type["bullet_damage"]
	bullet_speed = current_enemy_type["bullet_speed"]
	bullet_sound = current_enemy_type["bullet_sound"]	
	drop_currency = current_enemy_type["drop_currency"]	
	additional_vars = current_enemy_type["additional_vars"]
	if enemy_types[enemy_type].keys().find("can_rotate") != -1:
		if  current_enemy_type["can_rotate"] == true:
			can_rotate = true
		else:
			can_rotate = false
	else:
		can_rotate = false

	#loads bullet sound
	$ShootSound.stream = load(bullet_sound) 

const MIN_ARRIVE_DISTANCE = 50
const MAX_ARRIVE_DISTANCE = 400

func arrive_on_screen():
	position.y = -200
	var arrival_tween = get_tree().create_tween()
	#reset color to normal
	
	var distance = rng.randi_range(MIN_ARRIVE_DISTANCE,MAX_ARRIVE_DISTANCE)
	
	var duration = distance / SPEED
	
	arrival_tween.tween_property(self, "position:y", distance, duration)

func move_to_y(y_coord):
	var arrival_tween = get_tree().create_tween()
	#reset color to normal
	
	var distance = y_coord - position.y
	
	var duration = distance / SPEED
	
	arrival_tween.tween_property(self, "position:y", distance, duration)


func convert_to_ally():
	remove_from_group("Enemies")
	add_to_group("Player_Allies")
	rotation_degrees += 180
	Bullet = load("res://player_bullet.tscn")
	DeflectorShield = load("res://deflector_shield_player.tscn")
	can_drop_money = false
#	move_to_y(700)

func _ready():
	HP = MaxHP
	set_enemy_type(this_enemy_type)
#unlike player, enemies do not fire instantly
	attack_cooldown = firing_rate + rng.randf_range(-firing_rate_rand,firing_rate_rand)
	#loads bullet sound
	$ShootSound.stream = load(bullet_sound)


func _physics_process(delta):
	
	if can_rotate == true:
		#if ally, target first enemy in enemy array. otherwise target the player
		if self.is_in_group("Player_Allies"):
			var all_enemies = get_tree().get_nodes_in_group("Enemies")
			#print number of enemies
#			print(all_enemies.size())
			if all_enemies.size() > 0:	
				self.look_at(all_enemies[0].position)
				#hacky workaround since initial rotation is not quite correct
				self.rotation -= 1.6
		else:
			self.look_at(Globals.player_reference.position)
			#hacky workaround since initial rotation is not quite correct
			self.rotation -= 1.6
#	print(self.rotation)

	#to avoid weird bugs with rotation:

	$"Change Direction at Wall".global_rotation = 0

	attack_cooldown -= delta

	if attack_cooldown <= 0:
		shoot()
		attack_cooldown = firing_rate + rng.randf_range(-firing_rate_rand,firing_rate_rand)

	if additional_vars.keys().find("summon_enemy_type") != -1:
		summon_cooldown -= delta
		
		#added position check to avoid spawning enemies in unreachable spots
		if summon_cooldown <= 0 and position.y >= MIN_ARRIVE_DISTANCE:
			var e = summon_reference.instantiate()
			e.set_enemy_type(additional_vars["summon_enemy_type"])
			e.transform = transform
			e.can_drop_money = false#to avoid money farming
			get_tree().get_root().add_child(e)
#			e.arrive_on_screen()

			summon_cooldown = additional_vars["summon_enemy_rate"]

	if additional_vars.keys().find("has_shield") != -1:
		shield_cooldown -= delta
		if shield_cooldown <= 0:
			var shield = DeflectorShield.instantiate()
			shield.duration_left = additional_vars["shield_duration"]
			shield.scale_var = Vector2(additional_vars["shield_scale"],additional_vars["shield_scale"])
#shield moves with the player:
			self.add_child(shield)
			#this way, cooldown basically starts AFTER duration ends
			shield_cooldown = additional_vars["shield_duration"] + additional_vars["shield_cooldown_max"]
			$ShieldSound.play()



	velocity.x = SPEED * direction_x
	
	move_and_slide()

func shoot():

	$ShootSound.play()

#	var rng = RandomNumberGenerator.new()
	
	var bullets_left = bullets_amount
	
	var fixedspread_value = 0
	var fixedspread_step = 0

	if bullets_amount > 1:
		fixedspread_value = -bullet_fixed_spread / 2
		fixedspread_step = bullet_fixed_spread / (bullets_amount -  1)#subtracting one to prevent offset
	
	while bullets_left > 0:
		bullets_left -= 1
		var b = Bullet.instantiate()
		get_tree().get_root().add_child(b)
		b.transform = $Marker2D.global_transform
		b.damage = bullet_damage
		b.speed = bullet_speed
		b.rotation += rng.randf_range(-bullet_spread,bullet_spread)#random float spreaad
		b.rotation += fixedspread_value
#hacky workaround for the "projectile is briefly a child of the Enemy when created, and therefore becomes bigger" bug
		b.scale.x = 1
		b.scale.y = 1
		fixedspread_value += fixedspread_step
#		print(b.rotation)

func damage(num):
	HP -= num

	if additional_vars.keys().find("is_multiphase") != -1:
		if HP < MaxHP * additional_vars["multiphase_threshold"]:
			var orig_hp = HP
			set_enemy_type(additional_vars["multiphase_type"])
			HP = orig_hp
	
	#was originally fully-white, decided to make the damage flash a bit more subtle
#	$AnimatedSprite2D.modulate = Color(10,10,10)
	$Sprite2D.modulate = Color(2,2,2)
	var tween = get_tree().create_tween()
	#reset color to normal
	tween.tween_property($Sprite2D, "modulate", Color(1,1,1), 0.2)

	$HealthDisplay.update_healthbar(HP)
	if HP <= 0 and death_code_triggered == false:
		death_code_triggered = true
		if can_drop_money == true:
			Globals.Currency += drop_currency
		var b = Explosion.instantiate()
		b.position = position
		b.scale = scale
		get_tree().get_root().add_child(b)
		queue_free()

func _on_change_direction_at_wall_body_entered(body):
	if body.name == "Map_Border":
		direction_x = direction_x * -1
