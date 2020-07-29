extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 310
const ACCELERATION = 50
const KNOCKBACK = 2
const KNOCKBACKY = -150
var direction = 1
var target_direction = -1

var motion = Vector2()
var damagearr = []
const lazer_projectile = preload("res://Entities/lazerelec.tscn")
var lazer_velocity = 30

export var think = 0
export var up = 0
export var change = 0
export var ouch = 0

enum STATES {HEATMAN, IDLE, SHOOT, DEFEATED, ATTACKER, TAKE_DAMAGE, SHOOTUP, BYE}

export(int) var state = STATES.IDLE
export(float) var max_health = 40
onready var health = max_health setget _set_health
onready var player = globalls.player

onready var SeeEmCast = $SeeEmCast


var SeeEm = 0




func change_state(new_state):
	state = new_state

func _process(delta):
	motion.y += GRAVITY
	var friction = false

func _physics_process(delta):
	
	motion = move_and_slide(motion, UP)
	var type = "blue"
	for body in damagearr:
		body.take_damage(23, direction, type)

	if direction == 1:
		$Sprite.flip_h = false
	if direction == -1:
		$Sprite.flip_h = true

	match state:
		STATES.IDLE:
			idle()
		STATES.DEFEATED:
			dead()
		STATES.SHOOT:
			shoot()
		STATES.HEATMAN:
			foward()
		STATES.SHOOTUP:
			shootup()
		STATES.ATTACKER:
			attacker()
		STATES.BYE:
			bye()

	SeeEmCast.cast_to = globalls.player.position - position

	if SeeEmCast.is_colliding():
		var body = SeeEmCast.get_collider()
		if body.is_in_group("player"):
			think = 1



	if think == 1:
		var target_direction = sign(player.position.x - position.x)
		if target_direction != direction:
			if target_direction == -1:
				direction = -1
			elif target_direction == 1:
				direction = 1

#	print("ouch:",ouch,"   change:",change,"   up:",up,"   think:",think)

func reset():
	up = 0
	think = 0
	$See/PlayerHere.disabled = true
	change_state(STATES.IDLE)

func idle():
	ouch = 0
	$SeeUp/PlayerUp.disabled = true
	$See/PlayerHere.disabled = false
	motion.x = 0
	if think == 0:
		$AnimationPlayer.play("Idle")
	elif think == 1:
		if ouch == 0:
			change_state(STATES.ATTACKER)


func attacker():
	if change == 1:
		change_state(STATES.SHOOTUP)
	else:
		$AnimationPlayer.play("Attack")

func shootup():
	$AnimationPlayer.play("ShootUp")
	motion.x = 0

func _on_SeeUp_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			change = 1

func _on_SeeUp_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)
			change = 0

func foward():
	motion.x = SPEED * direction

func stop():
	motion.x = 0
	motion.y = motion.y * 3

func shoot():
	var lazer_instance = lazer_projectile.instance()
	lazer_instance.direction.x = direction
	lazer_instance.speed = lazer_velocity
	lazer_instance.position = (position+Vector2(direction*10,+5))
	lazer_instance.knockback = 9
	get_parent().add_child(lazer_instance)
	lazer_instance.get_node("AnimationPlayer").play("idle")

func shoot_up():
	var lazer_instance = lazer_projectile.instance()
	lazer_instance.direction.y = -1
	lazer_instance.speed = lazer_velocity
	lazer_instance.position = (position+Vector2(direction*10,+5))
	lazer_instance.knockback = 9
	get_parent().add_child(lazer_instance)
	lazer_instance.get_node("AnimationPlayer").play("idle")





func _on_See_body_entered(body):
	if ouch == 0:
		if body.is_in_group("player"):
			if !damagearr.has(body):
				think = 1

func _on_See_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)
			think = 0

const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	var kaboominstance = kaboom.instance()
	kaboominstance.position = (position+Vector2(0,18))
	get_parent().add_child(kaboominstance)


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				motion.y = (KNOCKBACKY)
				motion.x == (direction * -1 * KNOCKBACK) * 3
				change_state(STATES.DEFEATED)

func take_damage(damage, playerdirection, source, knock, type):
	if ouch == 0:
		change_state(STATES.TAKE_DAMAGE)
		if type == "blue":
			$AnimationPlayer.play("Hit")
		elif type == "red":
			change_state(STATES.IDLE)
		motion.y = (KNOCKBACKY) * 1.5

		if health <0:
			motion.x = sign((self.position.x - source.position.x)) * KNOCKBACK * 30
			motion.y = (KNOCKBACKY) * 5
		elif health >0:
			motion.x = sign((self.position.x - source.position.x)) * KNOCKBACK * knock

		_set_health(health - damage)
		direction = sign((self.position.x - source.position.x) * -1)

func dead():
	change_state(STATES.DEFEATED)
	$AnimationPlayer.play("HittDead")
	$HitEmArea/HitEmCol.disabled = true
	$See/PlayerHere.disabled = true
	$SeeUp/PlayerUp.disabled = true
	change = 0
	think = 0
	ouch = 1
	if is_on_floor():
		change_state(STATES.BYE)
	pass

func bye():
	$AnimationPlayer.play("Dead")

func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)
			var type = "blue"
			$AnimationPlayer.play("Punch")

func _on_HitEmArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)
