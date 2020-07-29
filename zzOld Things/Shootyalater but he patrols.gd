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

var target_direction = -1


onready var DesertWalk = $DesertWalk
onready var GonnaTurn = $GonnaTurn
onready var ShootTime = $ShootTime
enum STATES {WALKING,DEFEATED,DOINGSHOOT}
export(int) var state = STATES.WALKING
export(float) var max_health = 20

onready var health = max_health setget _set_health

export var IsThisIdiotCurrentlyOnMySight = 0
export var Isee = 0

var notice = 150
var direction = 1
var nextdir = 0
var nextdirtime = 3

export var busy = 0


func _ready():
	busy = 0
	ouch = 0

func set_dir(target_direction):
	if nextdir != target_direction:
		nextdir = target_direction
		nextdirtime = OS.get_ticks_msec() + notice

func change_state(new_state):
	state = new_state

func _physics_process(delta):
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(10, direction, type)

	if health <0:
		change_state(STATES.DEFEATED)

	if direction == 1:# && motion.x != 0:
		$Sprite.flip_h = false
		$HoleRay.position.x = 13.672
		$WallRay.position.x = 7.672
		$PatrolRay.rotation_degrees = 90
		$CollisionShape2D.position.x = 1.573
	if direction == -1:# && motion.x != 0:
		$Sprite.flip_h = true
		$HoleRay.position.x = -13.672
		$WallRay.position.x = -7.672
		$PatrolRay.rotation_degrees = -90
		$CollisionShape2D.position.x = -1.573



	match state:
		STATES.WALKING:
			pass
		STATES.DEFEATED:
			dead()
		STATES.DOINGSHOOT:
			doingshoot()

	if IsThisIdiotCurrentlyOnMySight == 1:
		if player.position.x < position.x - 1:
			set_dir(-1)
		elif player.position.x > position.x + 1:
			set_dir(1)
		else:
			set_dir(0)

	elif IsThisIdiotCurrentlyOnMySight == 0:
		if $HoleRay.is_colliding() == false && GonnaTurn.is_stopped():
			direction = direction *-1
			GonnaTurn.start()
			DesertWalk.start()

		if $PatrolRay.is_colliding() == true && GonnaTurn.is_stopped():
			direction = direction *-1
			GonnaTurn.start()
			DesertWalk.start()

		elif !GonnaTurn.is_stopped():
			motion.x = 0

		if !DesertWalk.is_stopped():
			if direction == 1:
				$PatrolRay.rotation_degrees = 90
			elif direction == -1:
				$PatrolRay.rotation_degrees = -90

		if DesertWalk.is_stopped():
			GonnaTurn.start()
			DesertWalk.start()


	if OS.get_ticks_msec() > nextdirtime && Isee == 1:
		direction = nextdir
	elif Isee == 0:
		pass

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	if direction == 0:
		motion.x = 0
		if is_on_floor():
			$AnimationPlayer.play("Idle")
###THIS SEEMS REDUNDANT, FIX LATER
	elif is_on_floor() && motion.x == 0 && busy == 0 && ouch == 0:
		$AnimationPlayer.play("Idle")


	if ouch == 0 && busy == 0:
		if abs(playerXdistance) < 240:
			if abs(playerYdistance) < 140:
				SeeEmCast.cast_to = player.position - position


		if SeeEmCast.is_colliding():
			var body = SeeEmCast.get_collider()
			if body.is_in_group("player"):
				Isee = 1
				IsThisIdiotCurrentlyOnMySight = 1
				var target_direction = sign(player.position.x - position.x)

				if abs(playerXdistance) <  240 && busy == 0 && ouch == 0 && IsThisIdiotCurrentlyOnMySight == 1 && Isee == 1:
					if abs(playerYdistance) < 35 && busy == 0 && ouch == 0 && IsThisIdiotCurrentlyOnMySight == 1 && Isee == 1:
						if ShootTime.is_stopped():
							change_state(STATES.DOINGSHOOT)



				if direction != 0 && ouch == 0 && busy == 0:
					if is_on_floor():
						if Isee == 0:
							motion.x = SPEED * direction
							$AnimationPlayer.play("Walk")
						if Isee == 1:
							motion.x = SPEED * (direction * -1)
							$AnimationPlayer.play("Walk")


			else:
				if ouch == 0 && busy == 0:
					Isee = 0
					IsThisIdiotCurrentlyOnMySight = 0
				if is_on_floor() && GonnaTurn.is_stopped():
					motion.x = SPEED * direction
					$AnimationPlayer.play("Walk")


const lazer_projectile = preload("res://Entities/Projectiles/lazer.tscn")
var lazer_velocity = 20

func shoot():
	var knockback = 30
	var lazer_instance = lazer_projectile.instance()
	lazer_instance.direction = direction
	lazer_instance.speed = lazer_velocity
	lazer_instance.position = (position+Vector2(direction*10,-4))
	lazer_instance.knockback = knockback
	get_parent().add_child(lazer_instance)
	$Shoot.play()


onready var player = globalls.player

onready var SeeEmCast = $SeeEmCast

### # MOVEMENT # ###

func walknowidiot():
	motion.x = SPEED * direction

func moonwalk():
	motion.x = (SPEED/2) * (direction *-1)

func stopmovingidiot():
	motion.x = 0

### # ATTACK STATES # ###

func doingshoot():
	if ShootTime.is_stopped():
		$AnimationPlayer.play("WalkBack")
		ShootTime.start()
		busy = 1
	if IsThisIdiotCurrentlyOnMySight == 0:
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
	ouch = 1
	busy = 1
	if health > 0:
		_set_health(health - damage)
		if type == "blue":
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
		change_state(STATES.DEFEATED)

func stomped():
	$AnimationPlayer.play("Stomped")
	motion.y = 0
	motion.x = 0
	$HitEmArea/HitEmCol.disabled = true

func dead():
	$AnimationPlayer.play("Bye2")
	motion.x == (direction * KNOCKBACK) * 300
	if is_on_floor() or is_on_ceiling() or is_on_wall():
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