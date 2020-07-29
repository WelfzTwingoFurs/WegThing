extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 190
const ACCELERATION = 30
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var jump = -360
var Above = 0
var motion = Vector2()
var damagearr = []

var target_direction = -1
var target_height = 0


onready var DesertWalk = $DesertWalk
onready var GonnaTurn = $GonnaTurn
onready var SlideTime = $SlideTime
enum STATES {WALKING, TAKE_DAMAGE, DEFEATED, SWING, SLIDE, GETUP}
export(int) var state = STATES.WALKING
export(float) var max_health = 30

onready var health = max_health setget _set_health

export var IsThisIdiotCurrentlyOnMySight = 0
export var Isee = 0

var notice = 150
var direction = 1
var nextdir = 0
var nextdirtime = 0

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
	var friction = false
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(13, direction, type)

	if health <0:
		change_state(STATES.DEFEATED)

	if direction == 1:# && motion.x != 0:
		$Sprite.flip_h = false
		$HoleRay.position.x = 13.672
		$WallRay.position.x = 7.672
		$LedgeRay.position.x = 15.462
		$LedgeRay.rotation_degrees = 65
		$PatrolRay.rotation_degrees = 90
		$CollisionShape2D.position.x = 1.573
		$SwordArea/SwordCol.position.x = 20
	if direction == -1:# && motion.x != 0:
		$Sprite.flip_h = true
		$HoleRay.position.x = -13.672
		$WallRay.position.x = -7.672
		$LedgeRay.position.x = -15.462
		$LedgeRay.rotation_degrees = -65
		$PatrolRay.rotation_degrees = -90
		$CollisionShape2D.position.x = -1.573
		$SwordArea/SwordCol.position.x = -20



	match state:
		STATES.DEFEATED:
			dead()
		STATES.TAKE_DAMAGE:
			pass#take_damage(damage, playerdirection, source, knock, type)
		STATES.SWING:
			Swing()
		STATES.SLIDE:
			Slide()
		STATES.GETUP:
			hurt()

	if IsThisIdiotCurrentlyOnMySight == 1:
		if player.position.x < position.x - 10:
			set_dir(-1)
		elif player.position.x > position.x + 10:
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
			#direction = direction *-1
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
			if Isee == 0:
				$AnimationPlayer.play("Idle")
			if Isee == 1:
				$AnimationPlayer.play("IdleSword")


	if !is_on_floor() && motion.y < 1 && busy == 0:
		$AnimationPlayer.play("Jump")
	if motion.y > 1 && !is_on_floor() && busy == 0:
		$AnimationPlayer.play("Fall")
		if is_on_floor():
			$Land.play


	elif is_on_floor() && motion.x == 0 && busy == 0 && ouch == 0:
		if Isee == 0:
			$AnimationPlayer.play("Idle")
		if Isee == 1:
			$AnimationPlayer.play("IdleSword")



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

				if abs(playerXdistance) < 32 && busy == 0 && ouch == 0:
					if abs(playerYdistance) < 35 && busy == 0 && ouch == 0:
						change_state(STATES.SWING)
						SlideTime.start()
						busy = 1

				if abs(playerXdistance) > 55 && busy == 0 && direction != 0 && ouch == 0 && is_on_floor():
					if abs(playerYdistance) < 15 && busy == 0 && direction != 0 && ouch == 0 && is_on_floor():
						if is_on_floor() && SlideTime.is_stopped() && busy == 0:
							change_state(STATES.SLIDE)
							busy = 1

				if abs(playerXdistance) < 50 && busy == 0:
					if abs(playerYdistance) > 20 && busy == 0:
						if is_on_floor():
							busy = 1
							SlideTime.start()
							$AnimationPlayer.play("GonnaJump")


				if direction != 0 && ouch == 0 && busy == 0:
					if is_on_floor():
						motion.x = SPEED * direction
						if Isee == 1:
							$AnimationPlayer.play("WalkSword")


			else:
				if ouch == 0 && busy == 0:
					Isee = 0
					IsThisIdiotCurrentlyOnMySight = 0
				if is_on_floor() && GonnaTurn.is_stopped():
					motion.x = (SPEED/2) * direction
					$AnimationPlayer.play("Walk")

#motion.x != 0


### # JUMPS # ###

		if motion.x != 0 && is_on_floor() && $HeadRay.is_colliding() == false && Isee == 1:
			if $WallRay.is_colliding() == true && player.position.y < position.y:
				$AnimationPlayer.play("GonnaJump")

			if $HoleRay.is_colliding() == false && player.position.y < position.y:
				$AnimationPlayer.play("GonnaJump")

			if $LedgeRay.is_colliding() == true && player.position.y < position.y - 16:
				$AnimationPlayer.play("GonnaJump")




onready var player = globalls.player

onready var SeeEmCast = $SeeEmCast


### # MOVEMENT # ###

func walknowidiot():
	motion.x = SPEED * direction

func stopmovingidiot():
	motion.x = 0

func nyooomm():
	motion.x = (jump * -1) * direction

func amgonnajump():
	motion.y = jump

### # ATTACK STATES # ###

func Swing():
	if is_on_floor():
		$AnimationPlayer.play("Swing")
	if !is_on_floor():
		$AnimationPlayer.play("AirSwing")

func Slide():
	SlideTime.start()
	busy = 1
	$AnimationPlayer.play("Slide")
	if !is_on_floor():
		change_state(STATES.WALKING)
		busy = 0

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
	change_state(STATES.TAKE_DAMAGE)

	if health > 0:
		_set_health(health - damage)
		if type == "blue":
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock * 2
			direction = sign((self.position.x - source.position.x)) * -1
			change_state(STATES.GETUP)



		elif type == "red":
			change_state(STATES.TAKE_DAMAGE)
			change_state(STATES.WALKING)
			motion.y = (KNOCKBACKY)
			direction = sign((self.position.x - source.position.x) * -1)



		elif type == "yellow":
			change_state(STATES.TAKE_DAMAGE)
			$AnimationPlayer.play("Stomped")
			motion.y = 0
			motion.x = 0
			$HitEmArea/HitEmCol.disabled = true



		else:
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock
			direction = sign((self.position.x - source.position.x)) * -1
			change_state(STATES.GETUP)

	if health <= 0:
		change_state(STATES.DEFEATED)

func hurt():
	change_state(STATES.GETUP)
	SlideTime.start()
	if !is_on_floor():
		$AnimationPlayer.play("Hit2")
	if is_on_floor():
		$AnimationPlayer.play("Hurt")








func stomped():
	change_state(STATES.TAKE_DAMAGE)
	$AnimationPlayer.play("Stomped")
	motion.y = 0
	motion.x = 0
	$HitEmArea/HitEmCol.disabled = true

func dead():
	change_state(STATES.DEFEATED)
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

func _on_SwordArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_SwordArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)

const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	var kaboominstance = kaboom.instance()
	kaboominstance.position = (position+Vector2(0,18))
	get_parent().add_child(kaboominstance)