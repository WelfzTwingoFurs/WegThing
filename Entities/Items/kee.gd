extends KinematicBody2D

export var thiskey = "fuck you"

func _ready():
	if thiskey == "red":
		$Sprite.modulate = Color(1,0,0,1)
	elif thiskey == "green":
		$Sprite.modulate = Color(0,1,0,1)
	elif thiskey == "blue":
		$Sprite.modulate = Color(0,0,1,1)
	else:
		print("ASSIGN THIS KEY A COLOR!")
		self.queue_free()

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		if thiskey == "red":
			body.redkey = 1
			self.queue_free()
		elif thiskey == "green":
			body.greenkey = 1
			self.queue_free()
		elif thiskey == "blue":
			body.bluekey = 1
			self.queue_free()
