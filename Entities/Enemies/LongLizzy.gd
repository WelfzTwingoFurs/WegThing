extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
var SPEED = 150
const MAX_SPEED = 80
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var motion = Vector2()
var damagearr = []

var current_speed = Vector2()
var current_acceleration = 2

enum STATES {IDLE,DEFEATED,TAKE_DAMAGE}
export(int) var state = STATES.IDLE

var jumpy = 1

var notice = 250
var nextdir = 0
var nextdirtime = 0
var target_direction = -1

export var Isee = 0

export var ouch = 0

export var busy = 0

var direction = 1

var lazer_projectile
func _ready():
	direction = randi()%2 +1
	change_state(STATES.IDLE)

func change_state(new_state):
	state = new_state

func set_dir(target_direction):
	if nextdir != target_direction:
		nextdir = target_direction
		nextdirtime = OS.get_ticks_msec() + notice

func _physics_process(delta):
	for body in damagearr:
		var type = "blue"
		body.take_damage(13, direction, type)



	if Input.is_action_pressed("wfz_movedown"):
		SeeEmCast.position.y = 5
	else:
		SeeEmCast.position.y = 1

	if direction == 2:
		direction = -1
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(18, direction, type)

	if direction == 1:
		$Sprite.flip_h = false
		$Sprite2.flip_h = false
		$CollisionShape2D.position.x = 0.3
		$HoleRay.position.x = -6
		$HeadCast.position.x = -7
	if direction == -1:
		$Sprite.flip_h = true
		$Sprite2.flip_h = true
		$CollisionShape2D.position.x = -0.3
		$HoleRay.position.x = 6
		$HeadCast.position.x = 7



	match state:
		STATES.IDLE:
			myself()
		STATES.DEFEATED:
			dead()
		STATES.TAKE_DAMAGE:
			pass

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	var WindowX = globalls.WindowX
	var WindowY = globalls.WindowY

	var target_direction = sign(player.position.x - position.x)

	if abs(playerXdistance) < (WindowX/4):
		if abs(playerYdistance) < (WindowY/4):
			SeeEmCast.cast_to = player.position - position
		else:
			Isee = 0
	else:
		Isee = 0

	if SeeEmCast.is_colliding():
		var body = SeeEmCast.get_collider()
		if body.is_in_group("player"):
			if Isee == 0:
				Isee = 1
		else:
			Isee = 0

	if Isee == 1:
		if busy != 1:
			if player.position.x < position.x - 1:
				set_dir(-1)
			elif player.position.x > position.x + 1:
				set_dir(1)
			else:
				pass

func myself():
	if OS.get_ticks_msec() > nextdirtime && Isee == 1:
		direction = nextdir

	if Isee == 1:
		if busy != 1:
			if direction == -1:
				if player.position.x > (position.x - 100):
					$AnimationPlayer.play("AttackBack")
			elif direction == 1:
				if player.position.x < (position.x + 100):
					$AnimationPlayer.play("Attack")
			else:
				$AnimationPlayer.play("Idle")
	elif Isee == 0:
		$AnimationPlayer.play("Idle")
		SPEED = 160

#	if busy != 1:
#		if direction == -1:
#			if player.position.x > (position.x - 50):
#				motion.x = SPEED * (direction *-1)
#			elif player.position.x > (position.x - 70):
#				motion.x = 0
#		elif direction == 1:
#			if player.position.x < (position.x + 50):
#				motion.x = SPEED * (direction *-1)
#			elif player.position.x < (position.x + 70):
#				motion.x = 0


func WalkBack():
	if direction == -1:
#		if player.position.x < (position.x - 70):
#			motion.x = SPEED * direction 
#		if player.position.x > (position.x - 50):
		motion.x += SPEED * (direction *-1)
	elif direction == 1:
#		if player.position.x > (position.x + 70):
#			motion.x = SPEED * direction
#		if player.position.x < (position.x + 50):
		motion.x += SPEED * (direction *-1)

func divide():
	pass
#	if SPEED > 85:
#		SPEED /= 2

onready var player = globalls.player
onready var SeeEmCast = $SeeEmCast

### # MOVEMENT # ###

func WalkFoward():
	if $HoleRay.is_colliding() == true:
		motion.x = MAX_SPEED * direction
	if $HoleRay.is_colliding() == false:
		motion.x = 0



func Jump():
	if player.position.y < position.y:
		if $HeadCast.is_colliding() == false:
			if is_on_floor():
				motion.y -= 250
				$Jump.play()

func literally_nothing():
	pass

func stopmovingidiot():
	motion.x = 0

### # HEALTHIES # ###

export(float) var max_health = 20

onready var health = max_health setget _set_health

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				change_state(STATES.DEFEATED)

func take_damage(damage, playerdirection, source, knock, type):
	if health >0:
		if ouch != 1:
			if type != "yellow":
				_set_health(health - damage)
			elif type == "yellow":
				stomped()
				ouch = 0


			if type == "red":
				ouch = 1
				motion.y = (KNOCKBACKY)
				direction = sign((self.position.x - source.position.x)) * -1
				$AnimationPlayer.play("Ouch")
				change_state(STATES.TAKE_DAMAGE)

			else:
				ouch = 1
				motion.y = (KNOCKBACKY)
				motion.x = sign((self.position.x - source.position.x)) * (knock *2.5)
				direction = sign((self.position.x - source.position.x))
				$AnimationPlayer.play("Ouch")
				change_state(STATES.TAKE_DAMAGE)

	if health < 1:
		ouch = 1
		motion.y = (KNOCKBACKY)
		motion.x = sign((self.position.x - source.position.x)) * (knock *2.5)
		direction = sign((self.position.x - source.position.x))
		change_state(STATES.DEFEATED)

func stomped():
	$AnimationPlayer.play("Stomped")
	motion.y = 0
	motion.x = 0
	$HitEmArea/CollisionShape2D.disabled = true
	$HitEmArea/Punch.disabled = true

func dead():
	$AnimationPlayer.play("Bye2")
	if is_on_floor():
		body()
		$AnimationPlayer.play("Bye")
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
	pass

const body = preload("res://Entities/Body.tscn")
func body():
	var bodyinstance = body.instance()
	bodyinstance.position = (position+Vector2(0,15))
	bodyinstance.slashem = true
	bodyinstance.direction = direction
	get_parent().add_child(bodyinstance)