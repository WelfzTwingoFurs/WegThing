extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15

var motion = Vector2()

var broken = false

enum STATES {IDLE, TAKE_DAMAGE}
export(int) var state = STATES.IDLE

func change_state(new_state):
	state = new_state

func _physics_process(delta):
	motion.x = 0
	motion.y += GRAVITY
	motion = move_and_slide(motion, UP)
	
	match state:
		STATES.IDLE:
			idle()
			pass
#		STATES.TAKE_DAMAGE:
#			take_damage()
			pass

func idle():
	$AnimationPlayer.play("idle")
	$HitArea/HurtBox.disabled = false
	$NormalCol.disabled = false
	$BrokenCol.disabled = true

func take_damage(damage, playerdirection, source, knock, type):
	change_state(STATES.TAKE_DAMAGE)
	$AnimationPlayer.play("broken")
	$HitArea/HurtBox.disabled = true
	$NormalCol.disabled = true
	$BrokenCol.disabled = false
	pass