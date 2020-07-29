extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 80
const ACCELERATION = 30
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var jump = -360
var motion = Vector2()
var damagearr = []

onready var DesertWalk = $DesertWalk
onready var GonnaTurn = $GonnaTurn
onready var ShootTime = $ShootTime
enum STATES {WALKING,DEFEATED,DOINGSHOOT,STOPANDRESETCUNT}
export(int) var state = STATES.WALKING
export(float) var max_health = 20

onready var health = max_health setget _set_health

export var Isee = 0

var notice = 150
var direction = 1
#var nextdir = 0
#var nextdirtime = 3
export var DontMotionX0 = 0

export var busy = 0


func _ready():
	direction = randi()%2 +1
	change_state(STATES.WALKING)
	busy = 0
	ouch = 0

#func set_dir(target_direction):
#	if nextdir != target_direction:
#		nextdir = target_direction
#		nextdirtime = OS.get_ticks_msec() + notice

func change_state(new_state):
	state = new_state

func _physics_process(delta):
	if Input.is_action_pressed("wfz_movedown"):
		SeeEmCast.position.y = 10
	else:
		SeeEmCast.position.y = 1
	
	if !$HoleRay.is_colliding() && ouch == 0 && state == STATES.DOINGSHOOT && DontMotionX0 == 0:
		motion.x = 0

	if direction == 2:
		direction = -1
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(10, direction, type)
		if is_on_floor():
			change_state(STATES.WALKING)

	if health <0:
		change_state(STATES.DEFEATED)

	if direction == 1:
		$Sprite.flip_h = false
		$Sprite2.flip_h = false
#		$HoleRay.position.x = 2.328
		$WallRay.position.x = -10
		$CollisionShape2D.position.x = 1.573
	if direction == -1:
		$Sprite.flip_h = true
		$Sprite2.flip_h = true
#		$HoleRay.position.x = -2.328
		$WallRay.position.x = 10
		$CollisionShape2D.position.x = -1.573


	match state:
		STATES.WALKING:
			pass
		STATES.DEFEATED:
			dead()
		STATES.DOINGSHOOT:
			doingshoot()
		STATES.STOPANDRESETCUNT:
			reset()

	if Isee == 1:
		if player.position.x < position.x - 1:
			direction = -1
		elif player.position.x > position.x + 1:
			direction = 1
		else:
			direction = 0

	elif Isee == 0:
		pass

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y



#	if direction == 0:
#		motion.x = 0
#		if is_on_floor():
#			$AnimationPlayer.play("Idle")
###THIS SEEMS REDUNDANT, FIX LATER
	if is_on_floor() && motion.x == 0 && busy == 0 && ouch == 0:#elif
		$AnimationPlayer.play("Idle")

	var WindowX = globalls.WindowX
	var WindowY = globalls.WindowY

	if ouch == 0 && busy == 0:
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
				var direction = sign(player.position.x - position.x)

				if abs(playerXdistance) <  240 && busy == 0 && ouch == 0 && Isee == 1:
					if abs(playerYdistance) < 35 && busy == 0 && ouch == 0 && Isee == 1:
						if ShootTime.is_stopped():
							change_state(STATES.DOINGSHOOT)
					elif abs(playerYdistance) > 35 && busy == 0 && ouch == 0 && Isee == 1:
						$AnimationPlayer.play("Seesyou")

			else:
				Isee = 0
				change_state(STATES.WALKING)

# WHY THE FUCK DOES IT NOT SWITCH TO ISEE = 0, MOTHERFUCKER, COME ON, WHAT THE FUCK IS WRONG WITH YOU #


const lazer_projectile = preload("res://Entities/Projectiles/lazer.tscn")

func shoot():
	var knockback = 0
	var lazer_instance = lazer_projectile.instance()
	lazer_instance.direction = direction
	lazer_instance.speed = 30
	lazer_instance.position = (position+Vector2(direction*10,-4))
	lazer_instance.knockback = knockback
	get_parent().add_child(lazer_instance)
	$Shoot.play()


onready var player = globalls.player

onready var SeeEmCast = $SeeEmCast
onready var SeeEmCast2 = $SeeEmCast2

### # MOVEMENT # ###

func walknowidiot():
	motion.x = SPEED * direction

func moonwalk():
	if $HoleRay.is_colliding():
		motion.x = (SPEED/2) * (direction *-1)
		$AnimationPlayer2.play("WalkBack")
	elif !$HoleRay.is_colliding() or $WallRay.is_colliding():
		stopmovingidiot()
		motion.x = 0
		$AnimationPlayer2.play("Stopped")

	if ouch == 1:
		stopmovingidiot()

func stopmovingidiot():
	$AnimationPlayer2.play("Stopped")
	motion.x = 0

### # ATTACK STATES # ###

func doingshoot():
	if Isee == 1:
		if ShootTime.is_stopped():
			$AnimationPlayer.play("Shoot")
			ShootTime.start()
			busy = 1
#		elif !$HoleRay.is_colliding() && ouch == 0 && busy == 1 && is_on_floor():
#			$AnimationPlayer.play("balance")
	elif Isee == 0 && busy == 0:
		change_state(STATES.WALKING)

func reset():
	Isee = 0
	$AnimationPlayer.play("Resetta")
	change_state(STATES.WALKING)


### # HEALTHIES # ###

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				change_state(STATES.DEFEATED)

export var ouch = 0

func take_damage(damage, playerdirection, source, knock, type):
	$ShootTime.stop()
	#ouch = 1
	busy = 1
	if health > 0 && ouch != 1:
		_set_health(health - damage)
		if type == "blue":
			ouch = 1
			$AnimationPlayer.play("Hit")
			ShootTime.start()
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock
			direction = sign((self.position.x - source.position.x)) * -1
		elif type == "red":
			change_state(STATES.WALKING)
			motion.y = (KNOCKBACKY)
			direction = sign((self.position.x - source.position.x) * -1)
		elif type == "yellow":
			$AnimationPlayer.play("Stomped")
			motion.y = 0
			motion.x = 0
			$HitEmArea/HitEmCol.disabled = true
		else:
			$AnimationPlayer.play("Hit")
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock
			direction = sign((self.position.x - source.position.x)) * -1
	if health <= 0:
		motion.y *= 1.1
		motion.x *= 1.3
		change_state(STATES.DEFEATED)



func stomped():
	$AnimationPlayer.play("Stomped")
	motion.y = 0
	motion.x = 0
	$HitEmArea/HitEmCol.disabled = true

func dead():
	DontMotionX0 = 1
	busy = 1
	ouch = 1
	$AnimationPlayer.play("Bye2")
#	motion.x == (direction * KNOCKBACK) * 400
#	$AnimationPlayer.play("Bye2")
#	motion.x += (direction * 10) *-1
	if is_on_floor():
		body()
		queue_free()
#		$AnimationPlayer.play("Bye")
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