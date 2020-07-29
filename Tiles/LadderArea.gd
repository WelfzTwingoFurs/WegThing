extends Area2D

var ladderarr = []

var hehere = 0

func _physics_process(delta):
	if Input.is_action_just_pressed('wfz_jump'):
		hehere = 0
	
	
	if Input.is_action_pressed("wfz_moveup") or Input.is_action_just_pressed("wfz_movedown"):
		if !Input.is_action_just_pressed('wfz_jump'):
			$CollisionShape2D.disabled = false
	else:
		if hehere == 0:
			$CollisionShape2D.disabled = true
	
	update()
	for body in ladderarr:
		if !Input.is_action_just_pressed('wfz_jump'):
			hehere = 1
			body.ladder = 1
			body.ladders(self)
#		if Input.is_action_just_pressed("wfz_moveup") or Input.is_action_just_pressed("wfz_movedown"):
#			body.ladder = 1
#			body.ladders(self)

func _on_LadderArea_body_entered(body):
	if body.is_in_group("player"):
		if !ladderarr.has(body):
				body.ladders(self)
				ladderarr.push_back(body)


func _on_LadderArea_body_exited(body):
	if body.is_in_group("player"):
		if ladderarr.has(body):
			ladderarr.erase(body)
			body.ladder = 0
			hehere = 0
