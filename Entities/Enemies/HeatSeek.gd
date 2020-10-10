extends KinematicBody2D
const GRAVITY = 15
const UP = Vector2(0, -1)
var motion = Vector2()
onready var player = globalls.player
var SPEED = 175
var damagearr = []

enum STATES {WAITING, COMING, OUCH}
export(int) var state = STATES.WAITING

var saveass = 0

func change_state(new_state):
	state = new_state

func _ready():
	change_state(STATES.WAITING)
	$AnimationPlayer.play("notboomies")
	killturret = 0
	ImDead = 0

func _physics_process(delta):
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		kaboom()
		queue_free()
	
	
	for body in damagearr:
		var type = "green"
		body.take_damage(33, direction, type)
	
	motion = move_and_slide(motion, UP)
	match state:
		STATES.WAITING:
			waiting()
		STATES.COMING:
			coming()
		STATES.OUCH:
			ouch()


	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	var WindowX = globalls.WindowX
	var WindowY = globalls.WindowY


	if abs(playerXdistance) < (WindowX/4):
		if abs(playerYdistance) < (WindowY/4):
			change_state(STATES.COMING)
			if saveass == 0:
				$AudioFire.play()
				saveass = 1
			elif saveass == 1:
				pass
			




	var X
	var Y
	
	if player.position.x < position.x - 10:
		if ImDead == 0:
			direction = -1
			X = -1
	elif player.position.x > position.x + 10:
		if ImDead == 0:
			direction = 1
			X = 1
	else:
		if ImDead == 0:
			direction = 0
			X = 0

	if player.position.y < position.y - 10:
		if ImDead == 0:
			directionY = -1
			Y = -1
	elif player.position.y > position.y + 10:
		if ImDead == 0:
			directionY = 1
			Y = 1
	else:
		if ImDead == 0:
			directionY = 0
			Y = 0

###################
	if X !=0:
		if Y == 1:
			if X == 1:
				$Sprite.frame = 8
		if Y == 1:
			if X == -1:
				$Sprite.frame = 6
		if Y == -1:
			if X == 1:
				$Sprite.frame = 2
		if Y == -1:
			if X == -1:
				$Sprite.frame = 0
###################
###################
	elif X == 0:
		if Y == 1:
			$Sprite.frame = 7
		if Y == -1:
			$Sprite.frame = 1
###################


###################
	if Y !=0:
		if X == 1:
			if Y == 1:
				$Sprite.frame = 8
		if X == 1:
			if Y == -1:
				$Sprite.frame = 2
		if X == -1:
			if Y == 1:
				$Sprite.frame = 6
		if X == -1:
			if Y == -1:
				$Sprite.frame = 0
###################
###################
	if Y == 0:
		if X == 1:
			$Sprite.frame = 5
		if X == -1:
			$Sprite.frame = 3
###################


var nextdir = 0
var nextdirtime = 0
var notice = 250
var direction = -1
var directionY = -1

func waiting():
	motion.x = 0
	motion.y = 0

func coming():
	if ImDead == 0:
		motion.x = SPEED * direction
		motion.y = SPEED * directionY

export var killturret = 1

func take_damage(damage, playerdirection, source, knock, type):
	$AudioHit.play()
	direction = sign((self.position.x - source.position.x))
	directionY = 0
	ImDead = 1
	SPEED = (SPEED * 1.35)
#	motion.y -= GRAVITY * 5
#	motion.x += (SPEED * direction) *2
	change_state(STATES.OUCH)

var ImDead = 0

func ouch():
	killturret = 1
	motion.x = SPEED * direction
	motion.y = 0
	var Y = 0
	
	if direction == 1:
		$Sprite.frame = 5
		motion.x *= 2
	elif direction == -1:
		$Sprite.frame = 3

func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player") && ImDead == 0:
		if !damagearr.has(body):
			damagearr.push_back(body)
			kaboom()

	if body.is_in_group("enemy"):
		if killturret == 1:
			ImDead = 1
			var knock = 0
			var playerdirection = direction
			body.take_damage(40, playerdirection, self, knock, "red")
			kaboom()
	
	if body.is_in_group("door"):
		ImDead = 1
		kaboom()
	if body.is_in_group("projectile"):
		ImDead = 1
		kaboom()

func _on_HitEmArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)

const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	motion.x = 0
	motion.y = 0
	ImDead = 1
	var kaboominstance = kaboom.instance()
	kaboominstance.position = (position+Vector2(0,0))
	get_parent().add_child(kaboominstance)
	$AnimationPlayer.play("boomies")
