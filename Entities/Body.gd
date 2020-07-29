extends KinematicBody2D
var direction

var slashem
var elecgen
var turret
var shootya


const GRAVITY = 15
var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY

func _ready():
	if slashem == true:
		if direction == 1:
			$AnimationPlayer.play("SlashemR")
		elif direction == -1:
			$AnimationPlayer.play("SlashemL")
		else:
			$AnimationPlayer.play("SlashemR")

	elif elecgen == true:
		if direction == 1:
			$AnimationPlayer.play("ElecgenR")
		elif direction == -1:
			$AnimationPlayer.play("ElecgenL")
		else:
			$AnimationPlayer.play("ElecgenR")

	elif turret == true:
		if direction == 1:
			$AnimationPlayer.play("TurretR")
		elif direction == -1:
			$AnimationPlayer.play("TurretL")
		else:
			$AnimationPlayer.play("TurretR")

	elif shootya == true:
		if direction == 1:
			$AnimationPlayer.play("ShootyaR")
		elif direction == -1:
			$AnimationPlayer.play("ShootyaL")
		else:
			$AnimationPlayer.play("ShootyaR")

	else:
		$AnimationPlayer.play("Noone")


const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	var kaboominstance = kaboom.instance()
	kaboominstance.position = (position+Vector2(0,18))
	get_parent().add_child(kaboominstance)