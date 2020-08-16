extends Node2D

#onready var inside = globalls.inside

func _physics_process(delta):
	var inside = globalls.inside
#	print(inside)
	if inside == 0:
		$Front.visible = 1
		$Back.visible = 0
	elif inside == 1:
		$Front.visible = 0
		$Back.visible = 1

#################

var newpausestate

func pause():
	newpausestate = not get_tree().paused 
	get_tree().paused = newpausestate
	visible = newpausestate

func unpause():
	if newpausestate == true:
		$AudioStreamPlayer.play()


#var position = 1
#func _input(event):
#	if event.is_action_pressed("ui_pause"):
#		newpausestate = not get_tree().paused 
#		get_tree().paused = newpausestate
#		visible = newpausestate
#		
#	if newpausestate == true:
#		if event.is_action_pressed("wfz_jump"):
#			$AudioStreamPlayer.play()



