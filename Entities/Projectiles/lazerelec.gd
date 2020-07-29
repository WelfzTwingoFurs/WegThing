extends KinematicBody2D

const UP = Vector2(0, -1)
var speed = 299
var knockback = 0
onready var player = globalls.player
var motion = Vector2()
var damagearr = []

# controls whether it acts as a player's projectile or an enemy projectile
var player_projectile = false

export var direction = Vector2(0,0)

func _ready():
	$AnimationPlayer.play("Idle")


func _physics_process(delta):
	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	if abs(playerXdistance) > 270:
		self.queue_free()
	if abs(playerYdistance) > 190:
		self.queue_free()


	motion = move_and_slide(motion, UP)
	motion.x = speed * direction.x
	motion.y = speed * direction.y


	for body in damagearr:
		body.take_damage(20, direction*knockback,"yellow")
		queue_free()

	if abs(motion.y) > 5:
		$Sprite.rotation_degrees = -90
	elif abs(motion.x) > 5:
		$Sprite.rotation_degrees = 0


func _on_LazerArea_body_entered(body):
	

	if player_projectile:
		# player projectile behavior
		if body.is_in_group("enemy"):
			var knockback = 0
			var playerdirection = direction
			body.take_damage(0, playerdirection, self, knockback, "yellow")
			self.queue_free()
	else:
		# enemy projectile behavior
		if body.is_in_group("player"):
			var type = "yellow"
			body.take_damage(0, direction*knockback, type)
			self.queue_free()
		if body.is_in_group("wall"):
			self.queue_free()

#func _on_LazerArea_body_exited(body):
#	pass # Replace with function body.
