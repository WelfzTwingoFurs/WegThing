extends KinematicBody2D

export var height = 6
export var fancy = 0

func _ready():
	if fancy == 0:
		$Sprite.texture = load("res://Graphics/Enemies/BlockerFucker.png")
	elif fancy == 1:
		$Sprite.texture = load("res://Graphics/Enemies/BlockerFucker2.png")
	
	if height == 6:
		$AnimationPlayer.play("6")
	if height == 5:
		$AnimationPlayer.play("5")
	if height == 4:
		$AnimationPlayer.play("4")
	if height == 3:
		$AnimationPlayer.play("3")
	if height == 2:
		$AnimationPlayer.play("2")
	if height == 1:
		$AnimationPlayer.play("1")
	height += 1

func _process(delta):
	$HurtArea/HurtCol.position.x = $CollisionShape2D.position.x
	$HurtArea/HurtCol.position.y = $CollisionShape2D.position.y
	$HurtArea/HurtCol.scale.x = $CollisionShape2D.scale.x
	$HurtArea/HurtCol.scale.y = $CollisionShape2D.scale.y

func take_damage(damage, playerdirection, source, knock, type):
	if $Timer.is_stopped():
		height -= 1
		$Timer.start()
		kaboom()
	
	if height == 6:
		$AnimationPlayer.play("5")
	if height == 5:
		$AnimationPlayer.play("4")
	if height == 4:
		$AnimationPlayer.play("3")
	if height == 3:
		$AnimationPlayer.play("2")
	if height == 2:
		$AnimationPlayer.play("1")
	if height == 1:
		queue_free()


const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	var kaboominstance = kaboom.instance()
	kaboominstance.position.x = (position.x-(3))
	var boomheight
	if height == 6:
		boomheight = -36
	if height == 5:
		boomheight = -20
	if height == 4:
		boomheight = -4
	if height == 3:
		boomheight = 12
	if height == 2:
		boomheight = 28
	if height == 1:
		boomheight = 44
	kaboominstance.position.y = (position.y+(boomheight))
	get_parent().add_child(kaboominstance)