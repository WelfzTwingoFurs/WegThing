extends KinematicBody2D
var motion = Vector2()
const MAX_SPEED = 45

enum STATES {IDLE}
export(int) var state = STATES.IDLE

export var angle = 0

onready var AngleCast = $Position2D/AngleCast

func change_state(new_state):
	state = new_state

func _ready():
	globalls.player = self

func _physics_process(delta):
	match state:
		STATES.IDLE:
			idle()
	for body in damagearr:
		body.showup(angle,self)
	
	angle = rad2deg(AngleCast.cast_to.angle())
#	print("PLAYER ANGLE:",angle)

func idle():
	if Input.is_action_pressed("wfz_moveright"):
		self.rotation_degrees += 1
	elif Input.is_action_pressed("wfz_moveleft"):
		self.rotation_degrees -= 1

	
	if Input.is_action_pressed("wfz_jump"):
		position.y -= 1
	if Input.is_action_pressed("wfz_slide"):
		position.y += 1
	if Input.is_action_pressed("wfz_kick"):
		position.x += 1
	if Input.is_action_pressed("wfz_weapon"):
		position.x -= 1

var damagearr = []

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_Area2D_body_exited(body):
	if body.is_in_group("enemy"):
		if damagearr.has(body):
			damagearr.erase(body)
			body.dissapear()
