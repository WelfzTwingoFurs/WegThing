extends KinematicBody2D

const UP = Vector2(0, -1)
var speed = 3
var knock = 0
var motion = Vector2()
var damagearr = []
var direction = 1
onready var player = globalls.player

func ready(delta):
	$AnimationPlayer.play("Idle")

func _physics_process(delta):
	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	if abs(playerXdistance) > 240:
		self.queue_free()
	if abs(playerYdistance) > 190:
		self.queue_free()
	
	motion = move_and_slide(motion, UP)
	
	for body in damagearr:
		body.take_damage(20, direction*knock)

	if !is_on_wall():
		motion.x += speed * direction
	if is_on_wall():
		$AnimationPlayer.play("Die")
	if motion.x == 0:
		$AnimationPlayer.play("Die")

func _on_LazerArea_body_entered(body):
	if body.is_in_group("enemy"):
		var knock = 0
		var playerdirection = direction
		body.take_damage(25, playerdirection, self, knock, "red")
