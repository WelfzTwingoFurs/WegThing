extends Node2D

enum STATES {ACTIVE, DEAD}
var current_state = STATES.ACTIVE
var motion = Vector2(0,0)
const GRAVITY = 15

var itsgonnabethisone = 0

func _ready():
	itsgonnabethisone = randi()%5 +1
	
	if itsgonnabethisone == 1:
		$AniPlay.play("Battery")
	if itsgonnabethisone == 2:
		$AniPlay.play("Chip")
	if itsgonnabethisone == 3:
		$AniPlay.play("Gear")
	if itsgonnabethisone == 4:
		$AniPlay.play("Nail")
	if itsgonnabethisone == 5:
		$AniPlay.play("Screw")

func _physics_process(delta):
	motion.y += GRAVITY
