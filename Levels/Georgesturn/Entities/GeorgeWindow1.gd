extends KinematicBody2D
var direction
onready var player = globalls.player

func _ready():
	$AnimationPlayer.playback_speed= randi()%3 +1
	$AnimationPlayer.play("gmod")

func _physics_process(delta):
	if player.position.x < position.x:
		$Sprite.flip_h = true
	elif player.position.x > position.x:
		$Sprite.flip_h = false
