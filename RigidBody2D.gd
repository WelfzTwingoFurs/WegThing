extends RigidBody2D

const UP = Vector2(0, -1)
enum STATES {ACTIVE, DEAD}
var current_state = STATES.ACTIVE
var motion = Vector2(0,0)
const GRAVITY = 15

var speed = 30
var damagearr = []
var direction = -1

func _process(delta):
	motion.y += GRAVITY
	var friction = false

func _physics_process(delta):
	motion = move_and_slide(motion, UP)
	motion.x += speed * direction

	if current_state == STATES.ACTIVE:
		$AnimationPlayer.play("Boom")