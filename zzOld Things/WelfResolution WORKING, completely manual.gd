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



	if Input.is_action_just_pressed("ui_resup"):#P
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2(resolutionx, resolutiony))
		OS.center_window()
		OS.window_size.x += 99
		resolutionx = OS.window_size.x

	elif Input.is_action_just_pressed("ui_resdown"):#O
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(resolutionx, resolutiony))
		OS.center_window()
		OS.window_size.y += 99
		resolutiony = OS.window_size.y




	if OS.window_size.x < resolutionx:
		OS.window_size.x = resolutionx

	if OS.window_size.y < resolutiony:
		OS.window_size.y = resolutiony


#	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,0, Vector2(resolutionx, resolutiony))
	
	if Input.is_action_pressed("ui_resback"):
		resolutionx /= 2#480
		resolutiony /= 2#279
		OS.window_size.x = 480
		OS.window_size.y = 279
		OS.center_window()

###############################
#	if Input.is_action_pressed("ui_resolution1"):
#		OS.window_size.x = 480
#		OS.window_size.y = 279
#		OS.center_window()

	if Input.is_action_just_pressed("ui_resolution1"):
		resolutionx /= 2#510
		resolutiony /= 2#371
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(resolutionx, resolutiony))
		OS.window_size.x = resolutionx
		OS.window_size.y = resolutiony
		OS.center_window()

	if Input.is_action_just_pressed("ui_resolution2"):
		resolutionx *= 2
		resolutiony *= 2
		OS.window_size.x *= 2
		OS.window_size.y *= 2
		OS.center_window()

## big boy ##
# 1020 x 742

## half boy ##
# 510 x 371

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