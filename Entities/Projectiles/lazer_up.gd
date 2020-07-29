extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 500
const ACCELERATION = 50
var speed = 3
var knockback = 10

var motion = Vector2()

var damagearr = []

var direction = -1

func ready(delta):
	$AnimationPlayer.play("Idle")



func _physics_process(delta):
	motion.y -= GRAVITY
	
	motion = move_and_slide(motion, UP)
	motion.y += speed * 1

	for body in damagearr:
		body.take_damage(20, direction*knockback)

func take_damage(damage, playerdirection, source, type):
	pass


func _on_LazerArea_body_entered(body):
	if body.is_in_group("player"):
		var type = "red"
		body.take_damage(20, direction*knockback, type)
#	if body.is_in_group("player"):
#		if !damagearr.has(body):
#			damagearr.push_back(body)
#
#func _on_LazerArea_body_exited(body):
#	if body.is_in_group("player"):
#		if damagearr.has(body):
#			damagearr.erase(body)