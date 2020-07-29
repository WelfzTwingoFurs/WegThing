extends TileMap

var ladderarr = []

func _physics_process(delta):
	for body in ladderarr:
		body.ladder = 1
		if Input.is_action_just_pressed("wfz_moveup") or Input.is_action_just_pressed("wfz_movedown"):
			body.ladders(self)

func _on_LadderArea_body_entered(body):
	if body.is_in_group("player"):
		if !ladderarr.has(body):
			ladderarr.push_back(body)

func _on_LadderArea_body_exited(body):
	if body.is_in_group("player"):
		if ladderarr.has(body):
			ladderarr.erase(body)
			body.ladder = 0
