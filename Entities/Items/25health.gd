extends KinematicBody2D

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		body.health += 25
		self.queue_free()