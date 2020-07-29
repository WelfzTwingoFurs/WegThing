extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 98
const KNOCKBACK = 1010
const KNOCKBACKY = -185
var motion = Vector2()
var damagearr = []

var direction = 1
export var Isee = 0

onready var SeeEmCast = $SeeEmCast
onready var SeeEmCast2 = $SeeEmCast2

func _physics_process(delta):
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(9, direction, type)

	if direction == 1:
		$Sprite.flip_h = false
	if direction == -1:
		$Sprite.flip_h = true

	motion.x = SPEED * direction

#	if $HoleRay.is_colliding() == false:
#		direction = direction *-1
	
	if is_on_wall():
		direction = direction * -1
		$HoleRay.position.x *= -1
		$WallRay.position.x *= -1
	if $WallRay.is_colliding():
		direction = direction * -1
		$HoleRay.position.x *= -1
		$WallRay.position.x *= -1




func take_damage(damage, playerdirection, source, knock, type):
	queue_free()

func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_HitEmArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)
