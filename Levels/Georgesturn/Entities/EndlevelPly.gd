extends KinematicBody2D

func _ready():
	$Sprite2.visible = false

func _on_WhoArea_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("encounter")

func changelevel():
	get_tree().change_scene("res://menu/Main menu/MainMenu2.tscn")