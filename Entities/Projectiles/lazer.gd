extends KinematicBody2D

const UP = Vector2(0, -1)
var speed = 2
var knockback = 0
var knock = 0
var motion = Vector2()
var damagearr = []
var direction = 1
onready var player = globalls.player
onready var time = $Timer


var player_projectile = false

func _ready():
	$LazerArea/LazerCol.disabled = false
	$CollisionShape2D.disabled = true
	time.start()
	$AnimationPlayer.play("idle")

func _physics_process(delta):
#	$AnimationPlayer.playback_speed = abs(motion.x)
	
	motion.y = 0
	if time.is_stopped():
		$CollisionShape2D.disabled = false
		$LazerArea/LazerCol.disabled = false
	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	if abs(playerXdistance) > 270:
		regularbehaviorofalazerbeamshot()
#		self.queue_free()
	if abs(playerYdistance) > 190:
		regularbehaviorofalazerbeamshot()
#		self.queue_free()

	motion = move_and_slide(motion, UP)
	motion.x += speed * direction

	for body in damagearr:
		body.take_damage(20, direction*knockback)

	motion.x += speed * direction
	if time.is_stopped():
		if is_on_ceiling() or is_on_floor() or is_on_wall():
			regularbehaviorofalazerbeamshot()
#			motion.x = 0
#			if direction == -1:
#				$AnimationPlayer.play("dieR")
#			elif direction == 1:
#				$AnimationPlayer.play("dieL")
#			else:
#				$AnimationPlayer.play("die")

	if motion.x == 0:# && time.is_stopped():
#		$AnimationPlayer.play("die")
		regularbehaviorofalazerbeamshot()

	if motion.y != 0:
#		motion.x = 0
#		$AnimationPlayer.play("die")
		regularbehaviorofalazerbeamshot()

#########AAAAAAAAAAAA#########
func regularbehaviorofalazerbeamshot():
	speed = 0
	motion.x = 0
	if direction == 1:
		$AnimationPlayer.play("dieR")
	elif direction == -1:
		$AnimationPlayer.play("dieL")
	elif direction == 0:
		$AnimationPlayer.play("die")
	else:
		$AnimationPlayer.play("die")

func take_damage(damage, playerdirection, source, knock):
	pass

func _on_LazerArea_body_entered(body):
	if player_projectile:
		if body.is_in_group("enemy"):
			var knock = 0
			var playerdirection = direction
			body.take_damage(25, playerdirection, self, knock, "red")
	else:
		if body.is_in_group("player"):
			var type = "red"
			body.take_damage(20, direction*0, type)








