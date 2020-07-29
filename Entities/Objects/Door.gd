extends KinematicBody2D

export var openIS = 0
export var opening = 0

export var big = 0

var doorarr = []
onready var player = globalls.player

func _physics_process(delta):
	if big == 0:
		$Sprite.texture = load("res://Graphics/More graphics/gamerdoor.png")
		$DudeArea/DudeArea.position.y = 0
		$DudeArea/DudeArea.scale.y = 1
		$CollisionShape2D.position.y = 4.009
		$CollisionShape2D.scale.y = 1
	elif big == 1:
		$Sprite.texture = load("res://Graphics/More graphics/gamerbigdoor.png")
		$DudeArea/DudeArea.position.y = -3.428
		$DudeArea/DudeArea.scale.y = 1.22
		$CollisionShape2D.position.y = 0.533
		$CollisionShape2D.scale.y = 1.24




	var player_direction = sign(player.position.x - position.x)
	
	for body in doorarr:
		#$CollisionShape2D.disabled = true
		if openIS == 0:
			if player_direction == -1:
				$AnimationPlayer.play("OpenR")
			elif player_direction == 1:
				$AnimationPlayer.play("OpenL")


func _on_DudeArea_body_entered(body):
	if body.is_in_group("player"):
		if !doorarr.has(body):
			doorarr.push_back(body)

func _on_DudeArea_body_exited(body):
	if body.is_in_group("player"):
		if doorarr.has(body):
			doorarr.erase(body)
#			$CollisionShape2D.disabled = false
			if openIS == -1:
				$AnimationPlayer.play("CloseL")
			elif openIS == 1:
				$AnimationPlayer.play("CloseR")

func take_damage(damage, playerdirection, source, knock, type):
	pass

func DoorCloseSND():
	$DoorClose.play()

func DoorOpenSND():
	$DoorOpen.play()
