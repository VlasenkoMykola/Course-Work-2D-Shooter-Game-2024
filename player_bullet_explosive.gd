extends Area2D

@export var speed = 0
@export var damage = 0
var explosion_hitbox_scale = 0

func set_explosion_size(size):
	explosion_hitbox_scale = size
	$Explode_Radius.scale = Vector2(size,size)

func _ready():
	$Explode_Radius.scale = Vector2(explosion_hitbox_scale,explosion_hitbox_scale)

func _physics_process(delta):
#	$Explode_Radius.scale = Vector2(explosion_hitbox_scale,explosion_hitbox_scale)
	position += transform.y * speed * delta
	set_explosion_size(explosion_hitbox_scale)

func _on_body_entered(body):
	if body.is_in_group("Enemies") or body.name == "Map_Border":
#		print("explosion collision scale "+str($Explode_Radius.scale))
#		var Explosion = load("res://explosion.tscn")
		var Explosion = load("res://player_bullet_anim_explosion.tscn")
		var b = Explosion.instantiate()
		b.position = position
		b.orig_explosion_scale = explosion_hitbox_scale
		get_tree().get_root().add_child(b)
#		print(b)
		for body2 in $Explode_Radius.get_overlapping_bodies():
			if body2.is_in_group("Enemies"):
				body2.damage(damage)
		queue_free()
