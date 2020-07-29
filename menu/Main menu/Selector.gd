extends KinematicBody2D

var motion = Vector2()

enum STATES {IDLE}
export(int) var state = STATES.IDLE

var newscene

func change_state(new_state):
	state = new_state
func _ready():
	newscene = "nothing"
	change_state(STATES.IDLE)

func _physics_process(delta):
	if newscene != "nothing":
		$Label.text = str(newscene)
	match state:
		STATES.IDLE:
			idle()
	motion = move_and_slide(motion, Vector2(0,-1))
	



func idle():
	if Input.is_action_pressed("wfz_moveright"):
		motion.x += 9
	if motion.x > 0:
		motion.x -= 4

	if Input.is_action_pressed("wfz_moveleft"):
		motion.x -= 9
	if motion.x < 0:
		motion.x += 4

	if motion.x == 0:
		motion.x = 0


	if Input.is_action_pressed("wfz_movedown"):
		motion.y += 9
	if motion.y > 0:
		motion.y -= 4

	if Input.is_action_pressed("wfz_moveup"):
		motion.y -= 9
	if motion.y < 0:
		motion.y += 4

	if motion.y == 0:
		motion.y = 0


	if Input.is_action_just_pressed("ui_accept") && newscene != "nothing":
		print(newscene)
		get_tree().change_scene(newscene)