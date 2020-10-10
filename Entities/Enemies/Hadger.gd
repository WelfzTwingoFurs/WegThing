extends KinematicBody2D

const UP = Vector2(0, -1)
var GRAVITY = 13
const SPEED = 133
const JUMPSPEED = 300
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var jump = -180
var motion = Vector2()
var damagearr = []

onready var DesertWalk = $DesertWalk
onready var GonnaTurn = $GonnaTurn
onready var ShootTime = $ShootTime
enum STATES {IDLE,DEFEATED,TAKETHAT,TAKE_DAMAGE}
export(int) var state = STATES.IDLE
export(float) var max_health = 10

onready var health = max_health setget _set_health

export var Isee = 0

var notice = 10
var nextdir = 0
var nextdirtime = 0
var target_direction = -1

var direction = 1
export var DontMotionX0 = 0

export var busy = 0

onready var player = globalls.player
onready var SeeEmCast = $SeeEmCast

func _ready():
	$CollisionShape2D.position.y = 7.343
	$CollisionShape2D.scale.x = 1
	$CollisionShape2D.scale.y = 1

func change_state(new_state):
	state = new_state

func set_dir(target_direction):
	if nextdir != target_direction:
		nextdir = target_direction
		nextdirtime = OS.get_ticks_msec() + notice

func _physics_process(delta):
	if Input.is_action_pressed("wfz_movedown"):
		SeeEmCast.position.y = 9
	else:
		pass
		SeeEmCast.position.y = 0

	match state:
		STATES.IDLE:
			idle()
		STATES.TAKETHAT:
			leap()
		STATES.DEFEATED:
			dead()
		STATES.TAKE_DAMAGE:
			pass
	
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		if health > 0:
			var type = "blue"
			body.take_damage(13, direction, type)
	if health <0:
		change_state(STATES.DEFEATED)
	elif Isee == 0:
		pass
	
	if !is_on_floor() && motion.y < 0 && Isee == 1:
		$CollisionShape2D.position.y = 0
		$CollisionShape2D.scale.x = 1
		$CollisionShape2D.scale.y = 0.6
	elif is_on_floor() or motion.y > 0 or Isee == 0:
		$CollisionShape2D.position.y = 7.343
		$CollisionShape2D.scale.x = 1
		$CollisionShape2D.scale.y = 1

	if direction == 1:
		$Sprite.flip_h = false
		$HoleRay.position.x = 10
		$WallRay.position.x = 10
	if direction == -1:
		$Sprite.flip_h = true
		$HoleRay.position.x = -10
		$WallRay.position.x = -10
	
	
	if Isee == 1:
		if jumpbusy == 0:
			if player.position.x < position.x - 1:
				set_dir(-1)
			elif player.position.x > position.x + 1:
				set_dir(1)
			else:
				pass
	
	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y
	
	var WindowX = globalls.WindowX
	var WindowY = globalls.WindowY
	
	if ouch == 0 && busy == 0:
		if abs(playerXdistance) < (WindowX/4):
			if abs(playerYdistance) < (WindowY/4):
				SeeEmCast.cast_to = player.position - position
	
		if SeeEmCast.is_colliding():
			var body = SeeEmCast.get_collider()
			if body.is_in_group("player"):
				Isee = 1
				if jumpbusy == 0:
					if abs(playerXdistance) > 89:
						walk()
						if is_on_floor() && !$HeadRay.is_colliding():
							if $WallRay.is_colliding() == true:
								leap()

							if !$HoleRay.is_colliding():
								if player.position.y > (position.y + 50):
									pass
								elif player.position.y < (position.y - 50):
									leap()

						elif $HeadRay.is_colliding():
							pass
					elif abs(playerXdistance) < 89:
						leap()
					else:
						pass
						#stop()

			else:
				Isee = 0

	if is_on_floor():
		jumpbusy = 0
	elif !is_on_floor():
		jumpbusy = 1

export var jumpbusy = 0

### # ATTACK STATES # ###

func idle():
	if OS.get_ticks_msec() > nextdirtime && Isee == 1:
		direction = nextdir
	
	if is_on_floor():
		if Isee == 0:
			$AnimationPlayer.play("IdleIDK")
#		if Isee == 1:
#			$AnimationPlayer.play("Idle")
	elif !is_on_floor():
		$AnimationPlayer.play("Jump")

func leap():
	$Jump.play()
	motion.x = direction * JUMPSPEED
	motion.y = jump

func leapjump():
	motion.x = direction * JUMPSPEED

func walk():
	motion.x = SPEED * direction
	$AnimationPlayer.play("Walk")

func stop():
	if is_on_floor():
		motion.x = 0
		$AnimationPlayer.play("Idle")
	elif !is_on_floor():
		$AnimationPlayer.play("Jump")

### # HEALTHIES # ###

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				change_state(STATES.DEFEATED)

export var ouch = 0

func take_damage(damage, playerdirection, source, knock, type):
	if health >0:
		if ouch == 0:
			if type != "yellow":
				_set_health(health - damage)
	
	if type == "red":
		ouch = 1
		motion.y = (KNOCKBACKY)
		direction = sign((self.position.x - source.position.x))
		change_state(STATES.TAKE_DAMAGE)
	elif type == "yellow":
		stomped()
		ouch = 0
	else:
		ouch = 1
		motion.y = (KNOCKBACKY)
		direction = sign((self.position.x - source.position.x))
		motion.x = (knock * 2.5) * -direction

		$AnimationPlayer.play("Ouch")
		change_state(STATES.TAKE_DAMAGE)
	if health <= 0:
		ouch = 1
		motion.y = (KNOCKBACKY)
		motion.x = (knock * 2.5) * direction
		kaboom()
		change_state(STATES.DEFEATED)

func stomped():
	$AnimationPlayer.play("Ouch")

func dead():
	GRAVITY = 15
	DontMotionX0 = 1
	busy = 1
	ouch = 1
	if is_on_floor():
		body()
		queue_free()
	pass

### # STINKY AREAS # ###

func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_HitEmArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)

const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	var kaboominstance = kaboom.instance()
	kaboominstance.position = (position+Vector2(0,18))
	get_parent().add_child(kaboominstance)

const body = preload("res://Entities/Body.tscn")
func body():
	var bodyinstance = body.instance()
	bodyinstance.position = (position+Vector2(0,15))
	bodyinstance.shootya = true
	bodyinstance.direction = direction
	get_parent().add_child(bodyinstance)