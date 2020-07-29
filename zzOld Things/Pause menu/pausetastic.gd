extends Control


func _input(event):
	if event.is_action_pressed("ui_pause"):
		var newpausestate = not get_tree().paused 
		get_tree().paused = newpausestate
		visible = newpausestate
		



onready var menuposition = 1
var option = begin

var mainmenu = 1

var begin = 0
var select = 0
var options = 0
var exit = 0

var beginmenu = 1
var exitmenu = 1
var selectmenu = 1

func _physics_process(delta):
	
	if mainmenu == 1:
		if Input.is_action_just_pressed("ui_moveup"):
			menuposition =menuposition - 1
			$Move.play()
		if Input.is_action_just_pressed("ui_movedown"):
			menuposition = menuposition + 1
			$Move.play()

	if menuposition == 0:
		menuposition = 4
	if menuposition == 5:
		menuposition = 1


	if menuposition == 1:
		$Selected.position.y = 62

	if menuposition == 2:
		$Selected.position.y = 85

	if menuposition == 3:
		$Selected.position.y = 109

	if menuposition == 4:
		$Selected.position.y = 131



	if mainmenu == 1:
		$Camera2D.position.x = -164
		$Background/yesB.visible = 0
		$Background/noB.visible = 0
		$Selected.position.x = 157
		if Input.is_action_just_pressed("ui_kick"):
			$Select.play()

			if menuposition == 1:
				begin = 1
				mainmenu = 0
				beginmenu = 0
				$Selected.position.x = 999

			if menuposition == 2:
				select = 1
				mainmenu = 0
				selectmenu = 0
				$Selected.position.x = 999

			if menuposition == 3:
				options = 1
				mainmenu = 0
				$Selected.position.y = 999

			if menuposition == 4:
				exit = 1
				mainmenu = 0
				exitmenu = 0
				$Selected.position.y = 999

###BEGIN###
	if begin == 1:
		$Background/yesB.visible = 1
		$Background/noB.visible = 1
		$Selected.position.y = 181
		
		if Input.is_action_just_pressed("ui_moveleft"):
			beginmenu = 1
			$Move.play()
		if Input.is_action_just_pressed("ui_moveright"):
			beginmenu = 2
			$Move.play()

		if beginmenu == 1:
			$Selected.position.x = 81
			if Input.is_action_just_pressed("ui_kick"):
				get_tree().change_scene("res://Levels/Level 1.tscn")

		if beginmenu == 2:
			$Selected.position.x = 241
			if Input.is_action_just_pressed("ui_kick"):
				$Selected.position.x = 156
				$Back.play()
				mainmenu = 1
				begin = 0

		if Input.is_action_just_pressed("ui_jump"):
			$Back.play()
			mainmenu = 1
			begin = 0

###LEVELS###
	if select ==1:
		$Background.position.x = 999
		$SelectMenu.position.x = 163

		if Input.is_action_just_pressed("ui_moveleft"):
			selectmenu = selectmenu - 1
			$Move.play()
			if selectmenu < 1:
				selectmenu = 3
		if Input.is_action_just_pressed("ui_moveright"):
			selectmenu = selectmenu + 1
			$Move.play()
			if selectmenu > 3:
				selectmenu = 1



		if selectmenu == 1:
			$Selected.position.x = 90
			if Input.is_action_just_pressed("ui_kick"):
				get_tree().change_scene("res://Levels/Level 1.tscn")

		if selectmenu == 2:
			$Selected.position.x = 157
			if Input.is_action_just_pressed("ui_kick"):
				get_tree().change_scene("res://Levels/Level 2.tscn")

		if selectmenu == 3:
			$Selected.position.x = 253
			if Input.is_action_just_pressed("ui_kick"):
				get_tree().change_scene("res://Levels/This thing.tscn")

		if Input.is_action_just_pressed("ui_jump"):
			$Back.play()
			mainmenu = 1
			select = 0
			$SelectMenu.position.x = 999
			$Background.position.x = 163

###OPTIONS###
	if options == 1:
		$Background.position.x = 999
		$OptionsMenu.position.x = 163
		
		if Input.is_action_just_pressed("ui_jump"):
			$Back.play()
			mainmenu = 1
			options = 0
			$OptionsMenu.position.x = 999
			$Background.position.x = 163

###EXIT
	if exit == 1:
		$Background.position.x = 999
		$ExitMenu.position.x = 163
		
		if Input.is_action_just_pressed("ui_moveup"):
			exitmenu = 1
			$Move.play()
		if Input.is_action_just_pressed("ui_movedown"):
			exitmenu = 2
			$Move.play()

		if exitmenu == 1:
			$Selected.position.y = 110
			if Input.is_action_just_pressed("ui_kick"):
				get_tree().quit()
	
		if exitmenu == 2:
			$Selected.position.y = 155
			if Input.is_action_just_pressed("ui_kick"):
				$Selected.position.x = 156
				$Back.play()
				mainmenu = 1
				exit = 0
				$ExitMenu.position.x = 999
				$Background.position.x = 163

		if Input.is_action_just_pressed("ui_jump"):
			$Back.play()
			mainmenu = 1
			exit = 0
			$ExitMenu.position.x = 999
			$Background.position.x = 163