extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const KNOCKBACK = 1010
const KNOCKBACKY = -210

var jump = -360
var motion = Vector2()
var damagearr = []

onready var ShootTime = $ShootTime
enum STATES {WALKING,DEFEATED,DOINGSHOOT,STOPANDRESETCUNT}
export(int) var state = STATES.WALKING
export(float) var max_health = 30

onready var health = max_health setget _set_health

export var Isee = 0

var notice = 150
var direction = 1

export var busy = 0


func _ready():
	$AnimationPlayer.play("Idle")
	direction = randi()%2 +1
	change_state(STATES.WALKING)
	busy = 0
	ouch = 0

func change_state(new_state):
	state = new_state

func _physics_process(delta):
	if Input.is_action_pressed("wfz_movedown"):
		SeeEmCast.position.y = 10
	else:
		SeeEmCast.position.y = 1

	if direction == 2:
		direction = -1
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(17, direction, type)
		if is_on_floor():
			change_state(STATES.WALKING)

	if health <0:
		change_state(STATES.DEFEATED)

	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = 1.573
		$HitEmArea/Punch.position.x = 568
	if direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1.573
		$HitEmArea/Punch.position.x = 544


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
#					if abs(playerYdistance) < 35 && busy == 0 && ouch == 0 && Isee == 1:
					if ShootTime.is_stopped():
						change_state(STATES.DOINGSHOOT)
#					elif abs(playerYdistance) > 35 && busy == 0 && ouch == 0 && Isee == 1:
#						$AnimationPlayer.play("Seesyou")

			else:
				Isee = 0

# WHY THE FUCK DOES IT NOT SWITCH TO ISEE = 0, MOTHERFUCKER, COME ON, WHAT THE FUCK IS WRONG WITH YOU #


const lazer_projectile = preload("res://Entities/Enemies/HeatSeek.tscn")

func shoot():
	var knockback = 0
	var lazer_instance = lazer_projectile.instance()
	lazer_instance.direction = direction
	lazer_instance.position = (position+Vector2(direction*10,-4))
	get_parent().add_child(lazer_instance)
	lazer_instance.get_node("AnimationPlayer").play("reallynotboomies")
	$Shoot.play()


onready var player = globalls.player

onready var SeeEmCast = $SeeEmCast

### # MOVEMENT # ###

func stopmovingidiot():
	motion.x = 0

func slowdown():
	motion.x = clamp(motion.x,-95,95)

func dash():
	motion.x += 190*direction
	#motion.x = clamp(motion.x,-10,10)

### # ATTACK STATES # ###

func doingshoot():
	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y
	if Isee == 1 && busy == 0:
		if ShootTime.is_stopped():
			if abs(playerXdistance) < 60:
				if abs(playerYdistance) < 20:
					$AnimationPlayer.play("Punch")
				else:
					$AnimationPlayer.play("Shoot")
			else:
				$AnimationPlayer.play("Shoot")
			ShootTime.start()
			busy = 1
	elif Isee == 0 && busy == 0:
		pass

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
	ShootTime.start()
	if health > 0:
		if type == "blue":
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Hit")
			motion.y = KNOCKBACKY
			motion.x += sign((self.position.x - source.position.x)) * knock *2
			direction = sign((self.position.x - source.position.x)) * -1
			#ouch = 1
			if ouch != 1:
				_set_health(health - damage)
		elif type == "green" or "red" or "yellow":
			busy = 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("Defend")
	if health <= 0:
		motion.y *= 1.1
		motion.x *= 1.3
		change_state(STATES.DEFEATED)

func dead():
	busy = 1
	ouch = 1
	$AnimationPlayer.play("Bye2")
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

func item():
	pass

const body = preload("res://Entities/Body.tscn")
func body():
	var bodyinstance = body.instance()
	bodyinstance.position = (position+Vector2(0,15))
	bodyinstance.elecgen = true
	bodyinstance.direction = direction
	get_parent().add_child(bodyinstance)