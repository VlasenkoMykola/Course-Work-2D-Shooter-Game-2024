extends Area2D

var Bullet : PackedScene = preload("res://player_bullet.tscn")

var duration_left = 0.0
var scale_var = Vector2(0,0)

#to prevent tweeen from being repeated
var tween_started = false

func _ready():
	self.modulate = Color(1,1,1,0)
	self.scale = Vector2(0,0)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a",1, 0.1)
	tween.tween_property(self, "scale", scale_var, 0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	duration_left -= delta
	if duration_left <= 0 and tween_started == false:
		tween_started = true
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(self, "modulate:a",0, 0.3)
		tween.tween_property(self, "scale",Vector2(0,0), 0.3)
		tween.set_parallel(false)
		tween.tween_callback(queue_free)

#func _on_body_entered(body):
#	if body.is_in_group("Enemy_Projectiles"):
#		print(body)

#workaround since bullets are done via Area2D

func _on_area_entered(area):
	if area.is_in_group("Enemy_Projectiles"):
		var b = Bullet.instantiate()
		b.transform = area.global_transform
#		print(b.rotation)
		#inverts direction
		b.rotation_degrees += 180
		b.damage = area.damage
		#deflected enemy bullets become faster
		b.speed = area.speed * 2
		get_tree().get_root().add_child(b)
#		print(area)
		area.queue_free()
