extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 150
const ACCELERATION = 50
const KNOCKBACK = 500
const KNOCKBACKY = -150

var jump = -300
var Above = 0
var motion = Vector2()
var damagearr = []

var target_direction = -1
var target_height = 0





enum STATES {WALKING, TAKE_DAMAGE, DEFEATED, SWING}
export(int) var state = STATES.WALKING
export(float) var max_health = 30

onready var health = max_health setget _set_health


var Isee = 0

var notice = 100
var direction = 1
var nextdir = 0
var nextdirtime = 0

export var busy = 0

func _ready():
	$AnimationPlayer.play("Idle")
	busy = 0
	ouch = 0

func set_dir(target_direction):
	if nextdir != target_direction:
		nextdir = target_direction
		nextdirtime = OS.get_ticks_msec() + notice


func change_state(new_state):
	state = new_state

func _process(delta):
	motion.y += GRAVITY
	var friction = false

func _physics_process(delta):
	
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(10, direction, type)

	if health <0:
		change_state(STATES.DEFEATED)

	if direction == 1 && motion.x != 0:
		$Sprite.flip_h = false
		$HoleRay.position.x = 13.672
		$WallRay.position.x = 7.672
		$LedgeRay.position.x = 15.462
		$SwordArea/SwordCol.position.x = 9
	if direction == -1 && motion.x != 0:
		$Sprite.flip_h = true
		$HoleRay.position.x = -13.672
		$WallRay.position.x = -7.672
		$LedgeRay.position.x = -15.462
		$SwordArea/SwordCol.position.x = -9

	if motion.y > 1000:
		queue_free()

	match state:
		STATES.DEFEATED:
			dead()
		STATES.TAKE_DAMAGE:
			pass#take_damage(damage, playerdirection, source, knock, type)
		STATES.SWING:
			Swing()

	if player.position.x < position.x - 10:
		if Isee == 1:
			set_dir(-1)
	elif player.position.x > position.x + 10:
		if Isee == 1:
			set_dir(1)
	else:
		set_dir(0)


	if OS.get_ticks_msec() > nextdirtime:
		direction = nextdir

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	if direction == 0:
		motion.x = 0
		if is_on_floor():
			$AnimationPlayer.play("Idle")
		if !is_on_floor() && motion.y < 0:
			$AnimationPlayer.play("Jump")
		elif motion.y > 0 && !is_on_floor():
			$AnimationPlayer.play("DownStab")


	if ouch == 0 && busy == 0:
		if abs(playerXdistance) < 190:
			if abs(playerYdistance) < 170:
				SeeEmCast.cast_to = player.position - position


		if SeeEmCast.is_colliding():
			var body = SeeEmCast.get_collider()
			if body.is_in_group("player"):
				Isee = 1
				var target_direction = sign(player.position.x - position.x)

				if abs(playerXdistance) < 32 && busy == 0:
					if abs(playerYdistance) < 32 && busy == 0:
						change_state(STATES.SWING)
						busy = 1

				if direction != 0:
					$AnimationPlayer.play("WalkSword")
					motion.x = SPEED * direction

			else:
				if ouch != 1 && busy != 1:
					Isee = 0
					motion.x = 0
					if is_on_floor():
						$AnimationPlayer.play("Idle")
					if !is_on_floor() && motion.y < 0:
						$AnimationPlayer.play("Jump")
					elif motion.y > 0 && !is_on_floor():
						$AnimationPlayer.play("DownStab")

		if motion.x != 0 && is_on_floor() && $HeadRay.is_colliding() == false && Isee == 1:
			if $WallRay.is_colliding() == true && player.position.y < position.y:
				motion.y = jump

			if $HoleRay.is_colliding() == false && player.position.y < position.y:
				motion.y = jump

			if $LedgeRay.is_colliding() == true && player.position.y < position.y - 16:
				motion.y = jump




onready var player = globalls.player

onready var SeeEmCast = $SeeEmCast




func walknowidiot():
	motion.x = SPEED * direction

func stopmovingidiot():
	motion.x = 0

func Swing():
	if is_on_floor():
		$AnimationPlayer.play("Swing")
	if !is_on_floor():
		$AnimationPlayer.play("AirSwing")


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				change_state(STATES.DEFEATED)

export var ouch = 0

func take_damage(damage, playerdirection, source, knock, type):
	ouch = 1
	change_state(STATES.TAKE_DAMAGE)
	if health > 0:
		_set_health(health - damage)
		if type == "blue":
			$AnimationPlayer.play("Hit")
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock
			direction = sign((self.position.x - source.position.x)) * -1
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
			$AnimationPlayer.play("Hit")
			motion.y = (KNOCKBACKY)
			motion.x = sign((self.position.x - source.position.x)) * knock
			direction = sign((self.position.x - source.position.x)) * -1
	if health <= 0:
		change_state(STATES.DEFEATED)

func stomped():
	change_state(STATES.TAKE_DAMAGE)
	$AnimationPlayer.play("Stomped")
	motion.y = 0
	motion.x = 0
	$HitEmArea/HitEmCol.disabled = true

func dead():
	change_state(STATES.DEFEATED)
	$AnimationPlayer.play("Stomped")
	$CollisionShape2D.disabled = true
	$HitEmArea/HitEmCol.disabled = true
	motion.x == (direction * KNOCKBACK * 200)
	pass

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
