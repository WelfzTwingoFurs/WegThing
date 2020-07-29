extends KinematicBody2D

const UP = Vector2(0, -1)
var motion = Vector2(0,0)
const GRAVITY = 15

var GOAWAY
var direction
export var upNdown = 0
var whoamI

export var broken = 0


func _ready():
	$PickArea/PickCol.disabled = true
	if direction != null:
		motion.x -= 45 * direction
		motion.y += -250
	elif direction == null:
		motion.x = 0
		motion.y = 0
		whoamI == "shootya"

	if whoamI == "2turret":
		$Sprite.texture = load("res://Graphics/Items/Red2turret.png")
	elif whoamI == "shootya":
		$Sprite.texture = load("res://Graphics/Items/RedGun.png")
	elif whoamI == "elecgen":
		$Sprite.texture = load("res://Graphics/Items/idiot.png")


func _physics_process(delta):
	motion = move_and_slide(motion, UP)
	motion.y += GRAVITY


	if !is_on_floor() && GOAWAY != 1:
		if direction == 1:
			$AnimationPlayer.play("SmackR")
			upNdown = 2

		if direction == -1:
			$AnimationPlayer.play("SmackL")
			upNdown = 2

	elif is_on_floor() && GOAWAY != 1:
		motion.x = 0
		$PickArea/PickCol.disabled = false
		if upNdown == 1:
			$AnimationPlayer.play("RipL")
		elif upNdown == 0:
			$AnimationPlayer.play("RipR")
		elif upNdown == 2:
			upNdown = randi()%1 +0


func _on_PickArea_body_entered(body):
	if body.is_in_group("player"):
		GOAWAY = 1
		$AnimationPlayer.play("Get")
		if whoamI == "shootya":
			body.red += 1
		elif whoamI == "2turret":
			body.red += 1
		elif whoamI == "elecgen":
			body.yellow += 3
		elif whoamI == null:
			body.red += 1