extends Area2D

@export var speed = 0
@export var damage = 0
@export var homing = false
#rotation speed is for homing:
#3 is the bare minimum that actually feels like proper homing. for faster projectiles, homing speed should be even faster
@export var rotation_speed = 10

var target = null

func get_target():
	var all_enemies = get_tree().get_nodes_in_group("Enemies")
	if all_enemies.size() > 0:
		var distance_away = self.global_transform.origin.distance_to(all_enemies[0].global_transform.origin)
		var return_node = all_enemies[0]
		for index in all_enemies.size():
			var distance = self.global_transform.origin.distance_to(all_enemies[index].global_transform.origin)
			if distance < distance_away:
				distance_away = distance
				return_node = all_enemies[index]
		target = return_node

func _physics_process(delta):
	position += transform.y * speed * delta
	if homing:
		var old_rotation = self.rotation
		if target == null:
			get_target()
		var all_enemies = get_tree().get_nodes_in_group("Enemies")
		
		#if target is destroyed, reset the target variable:
		if is_instance_valid(target):
			pass
		else:
			target = null

		if target:
			self.look_at(target.position)#hacky workaround since initial rotation is not quite correct
			self.rotation += 1.6
			var change = (self.rotation - old_rotation) * rotation_speed * delta
			self.rotation = old_rotation + change


func _on_body_entered(body):
	if body.is_in_group("Enemies"):
#scrapped "pierce is enemy is killed" code I was planning to use for sniper rifle.
#		if (body.HP - damage) > 0:
#			queue_free()
#		else:
#			pass
		body.damage(damage)
		queue_free()
	if body.name == "Map_Border":
		queue_free()
