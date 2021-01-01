extends Camera2D


var fixed_toggle_point = Vector2(0,0)

func _process(delta):
	if Input.is_action_just_released("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


	if Input.is_action_just_released("zoom_in"):
		zoom.x = zoom.x / 2
		zoom.y = zoom.y / 2
		
	if Input.is_action_just_released("zoom_out"):
		zoom.x = zoom.x * 2
		zoom.y = zoom.y * 2
		
	if Input.is_action_pressed("ui_up"):
		global_position.y -= 2
	elif Input.is_action_pressed("ui_down"):
		global_position.y += 2
	
	if Input.is_action_pressed("ui_left"):
		global_position.x -= 2
	elif Input.is_action_pressed("ui_right"):
		global_position.x += 2
