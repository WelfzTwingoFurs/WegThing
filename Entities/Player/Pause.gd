extends Control


func _input(event):
	if event.is_action_pressed("ui_pause"):
		var newpausestate = not get_tree().paused 
		get_tree().paused = newpausestate
		visible = newpausestate
		
