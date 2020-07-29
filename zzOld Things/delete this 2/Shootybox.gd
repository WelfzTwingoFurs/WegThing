extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 100

var motion = Vector2()

var direction = 1

func _process(delta):
	motion.y += GRAVITY
	var friction = false

func _physics_process(delta):
	motion.x = SPEED * direction
	$AnimatedSprite.play("Default")
	motion = move_and_slide(motion, UP)

	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1

	if direction == 1:
		$AnimatedSprite.flip_h = false
	if direction == -1:
		$AnimatedSprite.flip_h = true