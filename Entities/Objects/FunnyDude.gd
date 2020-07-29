extends RigidBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
var motion = Vector2()

func _process(delta):
	motion.y += GRAVITY
	var friction = false

func _physics_process(delta):
	motion.y += GRAVITY

func take_damage(damage, playerdirection, source, knock, type):
	$AnimationPlayer.play("Hit")
	motion.y = -150
#	motion.x = (playerdirection * 150)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Hit")

func stomped():
	$AnimationPlayer.play("Stomped")
	motion.y = -150
	motion.x = 0
