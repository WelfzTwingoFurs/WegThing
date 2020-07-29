extends KinematicBody2D
var motion = Vector2()
const UP = Vector2(0, -1)
const KNOCKBACKY = -100
var direction = 1
const GRAVITY = 9
export var grabbed = 0
onready var player = globalls.player
const MAX_SPEED = 45
var current_speed = Vector2()
var current_acceleration = 2

func _physics_process(delta):
	current_speed.x = clamp(current_speed.x,-MAX_SPEED,MAX_SPEED)
	current_acceleration = lerp(current_acceleration,2+abs(current_speed.x)*0.1,0.15)
	current_speed.x = lerp(current_speed.x,0,0.05)
	motion.x = lerp(motion.x,0,0.20)
#CONSTANTS#
	motion = move_and_slide(motion, UP)
	motion.y += GRAVITY

#GRAB#
	if grabbed == 1:
		position.y = player.position.y - 20
		position.x = player.position.x
	elif grabbed == 0:
		position.y = position.y
		position.x = position.x

#SPRITE DIRECTION#
#	if direction == -1:
#		$Sprite.flip_h = false
#	if direction == 1:
#		$Sprite.flip_h = true

func onfloor(source):#playerdirection or facing
	position.x = position.x + (20 * direction)
	direction = sign((self.position.x - source.position.x)) * -1
	$AnimationPlayer.play("letgo")
	grabbed = 0

func onhands():
	$AnimationPlayer.play("grabbed")
	grabbed = 1

func take_damage(damage, playerdirection, source, knock, type):
	if type == "blue":
		motion.y = (KNOCKBACKY)
		motion.x = sign((self.position.x - source.position.x)) * knock * 3
		direction = sign((self.position.x - source.position.x)) * -1
	elif type == "red":
		motion.y = (KNOCKBACKY)
		direction = sign((self.position.x - source.position.x) * -1)
	elif type == "yellow":
		pass
	else:
		motion.y = (KNOCKBACKY)
		motion.x = sign((self.position.x - source.position.x)) * knock * 3
		direction = sign((self.position.x - source.position.x)) * -1
