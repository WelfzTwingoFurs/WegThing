extends Area2D

var changearr = []
onready var inside = globalls.inside

func _physics_process(delta):
	var inside = globalls.inside
	for body in changearr:
		if inside == 0:
			if Input.is_action_just_pressed("wfz_moveup"):
				print(globalls.inside)
				globalls.inside = 1
		if inside == 1:
			if Input.is_action_just_pressed("wfz_moveup"):
				print(inside)
				globalls.inside = 0

func _on_ChangeArea_body_entered(body):
	if body.is_in_group("player"):
		if !changearr.has(body):
				changearr.push_back(body)

func _on_ChangeArea_body_exited(body):
	if body.is_in_group("player"):
		if changearr.has(body):
			changearr.erase(body)