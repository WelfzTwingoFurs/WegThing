extends Area2D

var damagearr = []
var thisscene

func _on_HitEmArea_body_entered(body):
	body.newscene = thisscene

func _on_HitEmArea_body_exited(body):
		body.newscene = "nothing"