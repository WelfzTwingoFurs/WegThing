extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 133
const JUMPSPEED = 500
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var jump = -180
var motion = Vector2()
var damagearr = []

onready var DesertWalk = $DesertWalk
onready var GonnaTurn = $GonnaTurn
onready var ShootTime = $ShootTime
enum STATES {IDLE,DEFEATED,TAKETHAT}
export(int) var state = STATES.IDLE
export(float) var max_health = 20

onready var health = max_health setget _set_health

export var Isee = 0

var notice = 150
var direction = 1
export var DontMotionX0 = 0

export var busy = 0

onready var player = globalls.player
onready var SeeEmCast = $SeeEmCast

func change_state(new_state):
	state = new_state

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
	
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(1, direction, type)
	if health <0:
		change_state(STATES.DEFEATED)
	
	
	elif Isee == 0:
		pass
	
	if direction == 1:
		$Sprite.flip_h = false
	if direction == -1:
		$Sprite.flip_h = true
	
	
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
				direction = sign(player.position.x - position.x)
	
				if abs(playerXdistance) >  120 && Isee == 1 && jumpbusy == 0:
					walk()
				else:
					stop()
	
				if abs(playerXdistance) <  90 && Isee == 1 && jumpbusy == 0:
					if abs(playerYdistance) < 50 && Isee == 1 && jumpbusy == 0:
						leap()

			else:
				Isee = 0

	if is_on_floor():
		jumpbusy = 0
	elif !is_on_floor():
		jumpbusy = 1

export var jumpbusy = 0

### # ATTACK STATES # ###

func idle():
	if is_on_floor():
		if Isee == 0:
			$AnimationPlayer.play("IdleIDK")
#		elif Isee == 1:
#			$AnimationPlayer.play("Idle")
	elif !is_on_floor():
		$AnimationPlayer.play("Jump")

func leap():
	motion.x = direction * JUMPSPEED
	motion.y = jump

func walk():
	motion.x = SPEED * direction
	$AnimationPlayer.play("Walk")

func stop():
	if is_on_floor():
		motion.x = 0
		$AnimationPlayer.play("Idle")

### # HEALTHIES # ###

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				change_state(STATES.DEFEATED)

export var ouch = 0

func take_damage(damage, playerdirection, source, knock, type):
	queue_free()
	busy = 1
	if health > 0 && ouch != 1:
		_set_health(health - damage)
		if type == "blue":
			ouch = 1
			$AnimationPlayer.play("Hit")
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock
		elif type == "red":
			change_state(STATES.IDLE)
			motion.y = (KNOCKBACKY)
		elif type == "yellow":
			#$AnimationPlayer.play("Stomped")
			$AnimationPlayer.play("Hit")
			motion.y = 0
			motion.x = 0
			$HitEmArea/HitEmCol.disabled = true
		else:
			$AnimationPlayer.play("Hit")
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock
	if health <= 0:
		motion.y *= 1.1
		motion.x *= 1.3
		change_state(STATES.DEFEATED)

func stomped():
	change_state(STATES.IDLE)

func dead():
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

const item = preload("res://Entities/Items/ItemDropped.tscn")
func item():
	var iteminstance = item.instance()
	iteminstance.position = (position+Vector2(0,15))
	iteminstance.direction = direction
	iteminstance.whoamI = "shootya"
	get_parent().add_child(iteminstance)
	
const body = preload("res://Entities/Body.tscn")
func body():
	var bodyinstance = body.instance()
	bodyinstance.position = (position+Vector2(0,15))
	bodyinstance.shootya = true
	bodyinstance.direction = direction
	get_parent().add_child(bodyinstance)