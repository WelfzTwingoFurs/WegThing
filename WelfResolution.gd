extends Node

var player

var resolutionx = 480
var resolutiony = 279

var WindowX = OS.window_size.x
var WindowY = OS.window_size.y

#var size = 1

func _ready():
	OS.window_size.x = resolutionx
	OS.window_size.y = resolutiony

func _process(delta):
	WindowX = OS.window_size.x
	WindowY = OS.window_size.y
	#If smaller than resolution, fix that#
	if OS.window_size.x < resolutionx:
		OS.window_size.x = resolutionx

	if OS.window_size.y < resolutiony:
		OS.window_size.y = resolutiony
	######################################

	if Input.is_action_pressed("ui_resback"):#BACKSPACE
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2(resolutionx, resolutiony))
		OS.center_window()
		OS.window_size.x += 9999999
		resolutionx = OS.window_size.x

		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_WIDTH, Vector2(resolutionx, resolutiony))
		OS.center_window()
		OS.window_size.y += 9999999
		resolutiony = OS.window_size.y

		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(resolutionx, resolutiony))



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