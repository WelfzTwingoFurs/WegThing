extends Node

var player

#var resolution = Vector2(480,279) 

var resolutionx = 480
var resolutiony = 279

#var size = 1

func _ready():
	OS.window_size.x = resolutionx
	OS.window_size.y = resolutiony

func _process(delta):
########## Braces, vertical ##########
	if Input.is_action_just_pressed("ui_resgrow"):
		resolutiony += 1
		OS.window_size.y += 1
	elif Input.is_action_just_pressed("ui_resungrow"):
		resolutiony -= 1
		OS.window_size.y -= 1
########## - and +, horizontal ##########
	if Input.is_action_just_pressed("ui_resmore"):
		resolutionx += 1
		OS.window_size.x += 1
	elif Input.is_action_just_pressed("ui_resless"):
		resolutionx -= 1
		OS.window_size.x -= 1



	if Input.is_action_just_pressed("ui_resup"):
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2(resolutionx, resolutiony))
	elif Input.is_action_just_pressed("ui_resdown"):
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(resolutionx, resolutiony))




	if resolutiony < 1:
		resolutiony = 1

#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,0, Vector2(resolutionx, resolutiony))
	
	if Input.is_action_pressed("ui_resback"):
		resolutionx = 480
		resolutiony = 279
		OS.window_size.x = 480
		OS.window_size.y = 279
		OS.center_window()

###############################
	if Input.is_action_pressed("ui_resolution1"):
		OS.window_size.x = 480
		OS.window_size.y = 279
		OS.center_window()

	if Input.is_action_pressed("ui_resolution2"):
		OS.window_size.x = resolutionx*2
		OS.window_size.y = resolutiony*2
		OS.center_window()

######Res auto-fixes######
#If smaller than 1, become 1
#	if OS.window_size.y < resolutiony:
#		OS.window_size.y = resolutiony
#		size = 1

#	if OS.window_size.y > resolutiony*2:
#		if OS.window_size.y < resolutiony*3:
#			OS.window_size.y = resolutiony*2
#			size = 2
#If bigger than 3 but smaller than 4, become 3
#	if OS.window_size.y > resolutiony*3:
#		if OS.window_size.y < resolutiony*4:
#			OS.window_size.y = resolutiony*3
#			size = 3