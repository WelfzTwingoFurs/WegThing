extends KinematicBody2D

func _on_WhoArea_body_entered(body):
	if body.is_in_group("cangrab"):
		$AnimationPlayer.play("encounter")

func changelevel():
	get_tree().change_scene("res://Levels/Georgesturn/Georgesturn2.tscn")