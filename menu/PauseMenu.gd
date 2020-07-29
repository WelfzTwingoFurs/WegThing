extends Control

var newpausestate
var position = 1

func _input(event):
	if event.is_action_pressed("ui_pause"):
		newpausestate = not get_tree().paused 
		get_tree().paused = newpausestate
		visible = newpausestate
		
	if newpausestate == true:
		if event.is_action_pressed("wfz_jump"):
			$AudioStreamPlayer.play()
#########
		if event.is_action_pressed("wfz_moveup"):
			if position == 1:
				position = 3
			else:
				position -= 1
		if event.is_action_pressed("wfz_movedown"):
			if position == 3:
				position = 1
			else:
				position += 1

		if position == 1:
			$Options.frame = 0
		if position == 2:
			$Options.frame = 1
		if position == 3:
			$Options.frame = 2

		if event.is_action_pressed("ui_accept"):
			newpausestate = not get_tree().paused 
			get_tree().paused = newpausestate
			visible = newpausestate
			if position == 1:
				pass
			if position == 2:
				get_tree().reload_current_scene()
			if position == 3:
				get_tree().change_scene("res://menu/Main menu/MainMenu2.tscn")