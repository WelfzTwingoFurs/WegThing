extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 100
const ACCELERATION = 50
const KNOCKBACK = 110
const KNOCKBACKY = -150

var motion = Vector2()

var damagearr = []

var direction = 1

enum STATES {WALKING, TAKE_DAMAGE, DEFEATED}
export(int) var state = STATES.WALKING
export(float) var max_health = 30

onready var health = max_health setget _set_health

func change_state(new_state):
	state = new_state




func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false
	
	motion = move_and_slide(motion, UP)
#	print(is_on_wall(),", ",$RayCast2D.is_colliding())
#	print(motion.y)

	for body in damagearr:
		var type = "blue"
		body.take_damage(10, direction, type)

	if motion.y < 150 and motion.y > -150 and health != 0:
		if is_on_wall():
			direction = direction * -1
			$RayCast2D.position.x *= -1
			$FallRay.position.x *= -1

		if $RayCast2D.is_colliding() == false:
			direction = direction * -1
			$RayCast2D.position.x *= -1
			$FallRay.position.x *= -1

	if direction == 1:
		$Sprite.flip_h = false
	if direction == -1:
		$Sprite.flip_h = true

	if motion.y > 1000:
		queue_free()

	match state:
		STATES.DEFEATED:
			dead()
		STATES.WALKING:
			walky()

func walky():
	
	if is_on_floor():
		motion.x = SPEED * direction
		if $FallRay.is_colliding() == false:
			direction = direction * -1
			$RayCast2D.position.x *= -1
			$FallRay.position.x *= -1

	if !is_on_wall():
		$AnimationPlayer.play("Walky")
		
	if motion.y > 0:
		if !is_on_floor():
			$AnimationPlayer.play("Fall")

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				change_state(STATES.DEFEATED)

func take_damage(damage, playerdirection, source, knock, type):
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

func dead():
	change_state(STATES.DEFEATED)
	$AnimationPlayer.play("Hit")
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