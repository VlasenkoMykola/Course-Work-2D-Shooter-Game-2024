extends Area2D

@export var speed = 0
@export var damage = 0

func _physics_process(delta):
	position += transform.y * speed * delta

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("Player_Allies"):
		body.damage(damage)
		queue_free()
	if body.name == "Map_Border":
		queue_free()
