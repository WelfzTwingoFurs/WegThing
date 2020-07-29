extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15

var motion = Vector2()

var skinarr = []

var skinname = 22

func _physics_process(delta):
	motion = move_and_slide(motion, UP)

	for body in skinarr:
		body.changeskin(skinname)

func _on_Area_body_entered(body):
    if body.is_in_group("player"):
        if !skinarr.has(body):
            skinarr.push_back(body)

func _on_Area_body_exited(body):
    if body.is_in_group("player"):
        if skinarr.has(body):
            skinarr.erase(body)