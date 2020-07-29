extends KinematicBody2D
var read = 0
onready var player = globalls.player

func _physics_process(delta):
	if read == 0:
		position.x = position.x
		position.y = position.y
	elif read == 1:
		position.x = player.position.x
		position.y = player.position.y

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("read")
		read = 1
