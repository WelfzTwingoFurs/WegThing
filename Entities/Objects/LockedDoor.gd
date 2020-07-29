extends KinematicBody2D

export var openIS = 0
#export var opening = 0

export var big = 0

var doorarr = []
onready var player = globalls.player

export var thisdoor = "lidl"

func _ready():
	if thisdoor == "red":
		$Sprite.modulate = Color(1,0,0,1)
	elif thisdoor == "green":
		$Sprite.modulate = Color(0,1,0,1)
	elif thisdoor == "blue":
		$Sprite.modulate = Color(0,0,1,1)
	else:
		print("ASSIGN THIS DOOR A COLOR!")
		self.queue_free()

func _physics_process(delta):
	if big == 0:
		$Sprite.texture = load("res://Graphics/More graphics/lockedgamerdoor.png")
		$DudeArea/DudeArea.position.y = 0
		$DudeArea/DudeArea.scale.y = 1
		$CollisionShape2D.position.y = 4.009
		$CollisionShape2D.scale.y = 1
	elif big == 1:
		$Sprite.texture = load("res://Graphics/More graphics/lockedgamerbigdoor.png")
		$DudeArea/DudeArea.position.y = -3.428
		$DudeArea/DudeArea.scale.y = 1.22
		$CollisionShape2D.position.y = 0.533
		$CollisionShape2D.scale.y = 1.24




	var player_direction = sign(player.position.x - position.x)
	
	for body in doorarr:
		if thisdoor == "red":
			if body.redkey == 1:
				$Label.visible = false
				if openIS == 0:
					if player_direction == -1:
						$AnimationPlayer.play("OpenR")
					elif player_direction == 1:
						$AnimationPlayer.play("OpenL")
			elif body.redkey == 0:
				$Label.visible = true

		if thisdoor == "green":
			if body.greenkey == 1:
				$Label.visible = false
				if openIS == 0:
					if player_direction == -1:
						$AnimationPlayer.play("OpenR")
					elif player_direction == 1:
						$AnimationPlayer.play("OpenL")
			elif body.greenkey == 0:
				$Label.visible = true

		if thisdoor == "blue":
			if body.bluekey == 1:
				$Label.visible = false
				if openIS == 0:
					if player_direction == -1:
						$AnimationPlayer.play("OpenR")
					elif player_direction == 1:
						$AnimationPlayer.play("OpenL")
			elif body.bluekey == 0:
				$Label.visible = true


func _on_DudeArea_body_entered(body):
	if body.is_in_group("player"):
		if !doorarr.has(body):
			doorarr.push_back(body)

func _on_DudeArea_body_exited(body):
	if body.is_in_group("player"):
		if doorarr.has(body):
			doorarr.erase(body)
			$Label.visible = false
#			if openIS == -1:
#				$AnimationPlayer.play("CloseL")
#			elif openIS == 1:
#				$AnimationPlayer.play("CloseR")

func take_damage(damage, playerdirection, source, knock, type):
	$DoorClose.play()

func DoorCloseSND():
	$DoorClose.play()

func DoorOpenSND():
	$DoorOpen.play()
