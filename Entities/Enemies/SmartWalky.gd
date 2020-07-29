extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 100
const ACCELERATION = 50
const KNOCKBACK = 200
const KNOCKBACKY = -150

var jump = -300
var Above = 0
var motion = Vector2()
var damagearr = []

var target_direction = -1
var target_height = 0





enum STATES {WALKING, TAKE_DAMAGE, DEFEATED, PUNCH}
export(int) var state = STATES.WALKING
export(float) var max_health = 30

onready var health = max_health setget _set_health




var notice = 100
var direction = 1
var nextdir = 0
var nextdirtime = 0


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
		body.take_damage(10, direction, type)

	if health <0:
		change_state(STATES.DEFEATED)

	if direction == 1 && motion.x != 0:
		$Sprite.flip_h = false
		$HoleRay.position.x *= -1
		$WallRay.position.x *= -1
		$LedgeRay.position.x *= -1
	if direction == -1 && motion.x != 0:
		$Sprite.flip_h = true
		$HoleRay.position.x *= -1
		$WallRay.position.x *= -1
		$LedgeRay.position.x *= -1

	if motion.y > 1000:
		queue_free()

	match state:
		STATES.DEFEATED:
			dead()
		STATES.TAKE_DAMAGE:
			pass#take_damage(damage, playerdirection, source, knock, type)
		STATES.PUNCH:
			punch()

	if player.position.x < position.x - 10:
		set_dir(-1)
	elif player.position.x > position.x + 10:
		set_dir(1)
	else:
		set_dir(0)


	if OS.get_ticks_msec() > nextdirtime:
		direction = nextdir

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	if ouch == 0:
		if abs(playerXdistance) < 240:
			if abs(playerYdistance) < 140:
				SeeEmCast.cast_to = player.position - position


		if SeeEmCast.is_colliding():
			var body = SeeEmCast.get_collider()
			if body.is_in_group("player"):
				var target_direction = sign(player.position.x - position.x)


				if direction != 0:
					$AnimationPlayer.play("Walky")
					motion.x = SPEED * direction


			elif direction == 0:
				motion.x = 0
				if is_on_floor():
					$AnimationPlayer.play("Idle")
				if !is_on_floor():
					$AnimationPlayer.play("Idle")

			else:
				motion.x = 0
				if is_on_floor():
					$AnimationPlayer.play("Idle")
				if !is_on_floor():
					$AnimationPlayer.play("Idle")

		if motion.x != 0:
			if is_on_floor():
				if $HeadRay.is_colliding() == false:
					if $WallRay.is_colliding() == true:
						if player.position.y < position.y:
							motion.y = jump

					if $HoleRay.is_colliding() == false:
						motion.y = jump

					if $LedgeRay.is_colliding() == true:
						if player.position.y < position.y - 16:
							motion.y = jump


		if motion.y < 0:
			if !is_on_floor():
				$AnimationPlayer.play("Fall")
			elif is_on_floor():
				$AnimationPlayer.play("Idle")

		if motion.y > 0:
			if !is_on_floor():
				$AnimationPlayer.play("Jump")
			elif is_on_floor():
				$AnimationPlayer.play("Idle")




onready var player = globalls.player

onready var SeeEmCast = $SeeEmCast








func punch():
	$AnimationPlayer.play("Punch")
	motion.x = 0


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
		change_state(STATES.PUNCH)
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_HitEmArea_body_exited(body):
    if body.is_in_group("player"):
        if damagearr.has(body):
            damagearr.erase(body)