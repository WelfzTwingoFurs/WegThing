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
	if OS.window_size.x < resolutionx:
		OS.window_size.x = resolutionx

	if OS.window_size.y < resolutiony:
		OS.window_size.y = resolutiony

	if Input.is_action_pressed("ui_resback"):#BACKSPACE
		var newresx 
		var newresy

		var readyx = 0
		var readyy = 0

		print("readyx=",readyx," readyy=",readyy)

		if newresx != OS.window_size.x:
			newresx = OS.window_size.x
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2(resolutionx, resolutiony))
			OS.center_window()
			OS.window_size.x += 9999999
			resolutionx = OS.window_size.x

		elif newresx == OS.window_size.x:
			readyx = 1

		if newresy != OS.window_size.y:
			newresy = OS.window_size.y
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(resolutionx, resolutiony))
			OS.center_window()
			OS.window_size.y += 9999999
			resolutiony = OS.window_size.y

		elif newresy == OS.window_size.y:
			readyy = 1


		if readyx == 1 && readyy == 1:
			resolutionx /= 2#510
			resolutiony /= 2#371
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(resolutionx, resolutiony))
			OS.window_size.x = resolutionx
			OS.window_size.y = resolutiony
			OS.center_window()

			resolutionx *= 2
			resolutiony *= 2
			OS.window_size.x *= 2
			OS.window_size.y *= 2
			OS.center_window()





#	if Input.is_action_just_pressed("ui_resup"):#P
#		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2(resolutionx, resolutiony))
#		OS.center_window()
#		OS.window_size.x += 9999999
#		resolutionx = OS.window_size.x

#	elif Input.is_action_just_pressed("ui_resdown"):#O
#		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(resolutionx, resolutiony))
#		OS.center_window()
#		OS.window_size.y += 9999999
#		resolutiony = OS.window_size.y



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

	if Input.is_action_just_pressed("ui_resolution3"):
		resolutionx /= 2#510
		resolutiony /= 2#371
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(resolutionx, resolutiony))
		OS.window_size.x = resolutionx
		OS.window_size.y = resolutiony
		OS.center_window()


		resolutionx *= 2
		resolutiony *= 2
		OS.window_size.x *= 2
		OS.window_size.y *= 2
		OS.center_window()
