extends KinematicBody2D
var motion = Vector2()
const MAX_SPEED = 45

enum STATES {IDLE}
export(int) var state = STATES.IDLE

export var angle = 0
func change_state(new_state):
	state = new_state
func _ready():
	globalls.player = self
func _physics_process(delta):
	match state:
		STATES.IDLE:
			idle()
	angle = $AngleCast.cast_to.angle()
	print("PLAYER ANGLE:",angle)



func idle():
	if Input.is_action_pressed("wfz_moveright"):
		$AngleCast.rotation_degrees += 1
		$Position2D.rotation_degrees += 1
	elif Input.is_action_pressed("wfz_moveleft"):
		$AngleCast.rotation_degrees -= 1
		$Position2D.rotation_degrees -= 1

	
	if Input.is_action_pressed("wfz_jump"):
		position.y -= 5
	if Input.is_action_pressed("wfz_slide"):
		position.y += 5
	if Input.is_action_pressed("wfz_kick"):
		position.x += 5
	if Input.is_action_pressed("wfz_weapon"):
		position.x -= 5

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		body.showup(angle,self)


func _on_Area2D_body_exited(body):
	pass # Replace with function body.
