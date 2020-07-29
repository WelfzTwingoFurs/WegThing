extends KinematicBody2D
var direction

func _ready():
	direction = randi()%2 +1

func _physics_process(delta):
	if direction == 1:
		$Sprite.flip_h = true
	elif direction == 2:
		$Sprite.flip_h = false
