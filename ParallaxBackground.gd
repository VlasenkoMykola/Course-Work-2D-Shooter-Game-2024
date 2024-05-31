extends ParallaxBackground

var scrolling_speed = -75

func smooth_background_change(new_texture):

#	print($"../Background Music")

	#set top layer to 0 alpha
	
	$ParallaxLayer_Transition/Sprite2D.modulate = Color(1,1,1,0)

	$ParallaxLayer_Transition/Sprite2D.texture = load(new_texture)

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($ParallaxLayer/Sprite2D, "modulate:a", 0, 5)
	tween.tween_property($ParallaxLayer_Transition/Sprite2D, "modulate:a", 1, 5)
	tween.set_parallel(false)
	#after the transition is over, replace bottom texture with the top one
	tween.tween_callback(background_change_end.bind(new_texture))

func background_change_end(new_texture):
	$ParallaxLayer/Sprite2D.texture = load(new_texture)
	$ParallaxLayer/Sprite2D.modulate = Color(1,1,1,1)
	$ParallaxLayer_Transition/Sprite2D.modulate = Color(1,1,1,0)
	

#func _ready():
#	smooth_background_change("res://sbs_-_seamless_space_backgrounds_-_large_1024x1024/Large 1024x1024/Purple Nebula/Purple Nebula 8 - 1024x1024.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.y -= scrolling_speed * delta
