extends Particles2D

const UP = Vector2(0, -1)
const GRAVITY = 10
const ACCELERATION = 50
var speed = 3

var motion = Vector2()

var direction = -1

enum STATES {DO}

export(int) var state = STATES.DO

func _physics_process(delta):
	match state:
		STATES.DO:
			do()

func do():
	$AnimationPlayer.play("Cough")
	motion.x += speed * direction

func ready(delta):
	$AnimationPlayer.play("Cough")

func take_damage(damage, playerdirection, source):
	pass