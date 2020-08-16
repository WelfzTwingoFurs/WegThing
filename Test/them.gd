extends KinematicBody2D

onready var player = globalls.player
onready var view = globalls.view
onready var SeeEmCast = $SeeEmCast

var playerposition
var playangle
var long
var length

func _physics_process(delta):
	SeeEmCast.cast_to = player.position - position
	playerposition = (SeeEmCast.get_collision_point() - position)
#	print(playangle)
	playangle = rad2deg(SeeEmCast.cast_to.angle())
	length = SeeEmCast.cast_to.length()
#	print(length)

#draw_line(Vector2(-5,ray.position.y), (ray.get_collision_point() - position), Color8(255, 0, 0)/3, 1)
#
func showup(angle,source):
	$Sprite2.visible = true
	$Sprite2.position.y = view.position.y - position.y
	$Sprite2.position.x = (playangle*2 - position.x) + view.position.x/1.25
	$Sprite2.scale.x = max(1 - length/150, 0) * 10
	$Sprite2.scale.y = max(1 - length/150, 0) * 10

func dissapear():
	$Sprite2.visible = false