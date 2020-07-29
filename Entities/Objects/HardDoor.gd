extends KinematicBody2D

export var opentime = 0

export var big = 0

var doorarr = []
onready var player = globalls.player

func _ready():
	if big == 0:
		$Sprite.texture = load("res://Graphics/More graphics/hardgamerdoor.png")
		$CollisionShape2D.position.y = 4.009
		$CollisionShape2D.scale.y = 1
	elif big == 1:
		$Sprite.texture = load("res://Graphics/More graphics/hardgamerbigdoor.png")
		$CollisionShape2D.position.y = 0.533
		$CollisionShape2D.scale.y = 1.24
	
	opentime = 0

func _physics_process(delta):
	var player_direction = sign(player.position.x - position.x)
	
	if opentime == 1:
		$CollisionShape2D.disabled = true
		if player_direction == -1:
			$AnimationPlayer.play("OpenR")
		elif player_direction == 1:
			$AnimationPlayer.play("OpenL")

func take_damage(damage, playerdirection, source, knock, type):
	if opentime == 0:
		$AudioStreamPlayer2D.play()
		$CollisionShape2D.disabled = true
		opentime = 1
	else:
		pass
