extends Node

var player

var resolution = Vector2(480,279) 

var resolutionx = 480
var resolutiony = 279

var size = 1

func _ready():
	OS.window_size.x = resolutionx

func _process(delta):
		if Input.is_action_just_pressed("ui_resolution1"):
			OS.window_size = resolution*1
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution2"):
			OS.window_size = resolution*2
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution3"):
			OS.window_size = resolution*3
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution4"):
			OS.window_size = resolution*4
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution5"):
			OS.window_size = resolution*5
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution6"):
			OS.window_size = resolution*6
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution7"):
			OS.window_size = resolution*7
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution8"):
			OS.window_size = resolution*8
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution9"):
			OS.window_size = resolution*9
			OS.center_window()
		elif Input.is_action_just_pressed("ui_resolution0"):
			OS.window_size = resolution*10
			OS.center_window()


	if size > 10:
		size = 10
	if size < 1:
		size = 1

	if Input.is_action_just_pressed("ui_resmore"):
		size = size+1
	elif Input.is_action_just_pressed("ui_resless"):
		size = size-1


	OS.window_size.y = resolutiony*size


######Res auto-fixes######
#If smaller than 1, become 1
	if OS.window_size.y < resolutiony:
		OS.window_size.y = resolutiony
		size = 1
#If bigger than 1 but smaller than 2, become 1
	if OS.window_size.y > resolutiony:
		if OS.window_size.y < resolutiony*2:
			OS.window_size.y = resolutiony
			size = 1
#If bigger than 2 but smaller than 3, become 2
	if OS.window_size.y > resolutiony*2:
		if OS.window_size.y < resolutiony*3:
			OS.window_size.y = resolutiony*2
			size = 2
#If bigger than 3 but smaller than 4, become 3
	if OS.window_size.y > resolutiony*3:
		if OS.window_size.y < resolutiony*4:
			OS.window_size.y = resolutiony*3
			size = 3
#If bigger than 4 but smaller than 5, become 4
	if OS.window_size.y > resolutiony*4:
		if OS.window_size.y < resolutiony*5:
			OS.window_size.y = resolutiony*4
			size = 4
#If bigger than 5 but smaller than 6, become 5
	if OS.window_size.y > resolutiony*5:
		if OS.window_size.y < resolutiony*6:
			OS.window_size.y = resolutiony*5
			size = 5
#If bigger than 6 but smaller than 7, become 6
	if OS.window_size.y > resolutiony*6:
		if OS.window_size.y < resolutiony*7:
			OS.window_size.y = resolutiony*6
			size = 6
#If bigger than 7 but smaller than 8, become 7
	if OS.window_size.y > resolutiony*7:
		if OS.window_size.y < resolutiony*8:
			OS.window_size.y = resolutiony*7
			size = 7
#If bigger than 8 but smaller than 9, become 8
	if OS.window_size.y > resolutiony*8:
		if OS.window_size.y < resolutiony*9:
			OS.window_size.y = resolutiony*8
			size = 8
#If bigger than 9 but smaller than 10, become 9
	if OS.window_size.y > resolutiony*9:
		if OS.window_size.y < resolutiony*10:
			OS.window_size.y = resolutiony*9
			size = 9
#If bigger than 10, become 10
	if OS.window_size.y > resolutiony*10:
		OS.window_size.y = resolutiony*10
		size = 10