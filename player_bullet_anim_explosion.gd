extends Node2D

var orig_explosion_scale = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var scale1 = orig_explosion_scale * 0.66
	var scale2 = orig_explosion_scale * 1.2
#	print(orig_explosion_scale)
#	scale = Vector2(orig_explosion_scale,orig_explosion_scale)
	$Sprite2D.scale = Vector2(scale1,scale1)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "modulate:a",0, 0.3)
	tween.tween_property($Sprite2D, "scale",Vector2(scale2,scale2), 0.3)
	tween.set_parallel(false)
#object now despawns when sound ends instead of when animation finishes
#	tween.tween_callback(queue_free)


func _on_audio_stream_player_finished():
	queue_free()
