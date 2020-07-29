extends KinematicBody2D

const UP = Vector2(0, -1)
enum STATES {ACTIVE, DEAD}
var current_state = STATES.ACTIVE
var motion = Vector2(0,0)
const GRAVITY = 15

var speed = -30
var direction = -1

export var broken = 0

#onready var particle = $Particles2D


func _physics_process(delta):
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
#	motion.x += speed * direction
	if is_on_floor():
		broken = 1
		$AnimationPlayer.play("Break")
		motion.x = 0
		

	if broken == 1:
		if is_on_floor():
			$Gun.visible = 0
			$GunBad2.visible = 0
			$GunBad.visible = 1
#			particle.emitting = 1
		if !is_on_floor():
#			particle.emitting = 0
			$Gun.visible = 0
			$GunBad2.visible = 1
			$GunBad.visible = 0

func _ready():
	if broken == 0:
		motion.x += speed * direction
		motion.y += -300

	if current_state == STATES.ACTIVE:
		if broken == 0:
			$AnimationPlayer.play("Boom")

func bounce():
	motion.y += -100