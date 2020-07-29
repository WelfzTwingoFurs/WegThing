extends KinematicBody2D

enum STATES {ACTIVE, DEAD}
var current_state = STATES.ACTIVE
var motion = Vector2(0,0)

#const spark_projectile = preload("res://Entities/Effects/Fireworks.tscn")

func _physics_process(delta):
	pass

	if current_state == STATES.ACTIVE:
		$AniBoom.play("Boom")