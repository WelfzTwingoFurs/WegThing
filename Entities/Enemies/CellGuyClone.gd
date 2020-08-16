extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 100
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var motion = Vector2()
var damagearr = []

enum STATES {IDLE}
export(int) var state = STATES.IDLE

export var Isee = 1

var direction = 1

var lazer_projectile
func _ready():
	direction = randi()%2 +1
	change_state(STATES.IDLE)

func change_state(new_state):
	state = new_state


func _physics_process(delta):
	if Input.is_action_pressed("wfz_movedown"):
		SeeEmCast.position.y = 10
	else:
		SeeEmCast.position.y = 1

	if direction == 2:
		direction = -1
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, UP)
	for body in damagearr:
		var type = "blue"
		body.take_damage(18, direction, type)

	if direction == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.position.x = 1.573
	if direction == -1:
		$Sprite.flip_h = true
		$CollisionShape2D.position.x = -1.573


	match state:
		STATES.IDLE:
			myself()

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	var WindowX = globalls.WindowX
	var WindowY = globalls.WindowY

	if abs(playerXdistance) < (WindowX/4):
		if abs(playerYdistance) < (WindowY/4):
			SeeEmCast.cast_to = player.position - position
		else:
			queue_free()
	else:
		queue_free()

	if SeeEmCast.is_colliding():
		var body = SeeEmCast.get_collider()
		if body.is_in_group("player"):
			if Isee == 0:
				Isee = 1
		else:
			Isee = 0

	if Isee == 1:
		if player.position.x < position.x - 1:
			direction = -1
		elif player.position.x > position.x + 1:
			direction = 1
		else:
			pass

func myself():
	if Isee == 1:
		$AnimationPlayer.play("Attack")
	elif Isee == 0:
		$AnimationPlayer.play("Idle")


onready var player = globalls.player
onready var SeeEmCast = $SeeEmCast

### # MOVEMENT # ###

func WalkFoward():
	$HoleRay.position.x = -2.328
	$WallRay.position.x = 10
	$Sprite.texture = load("res://Graphics/Enemies/CellGuy.png")
	
	if $HoleRay.is_colliding():
		motion.x = SPEED
	elif !$HoleRay.is_colliding() or $WallRay.is_colliding():
		motion.x = 0

func WalkBack():
	$HoleRay.position.x = 2.328
	$WallRay.position.x = -10
	$Sprite.texture = load("res://Graphics/Enemies/CellGuy.png")
	if $HoleRay.is_colliding():
		motion.x = -SPEED
	elif !$HoleRay.is_colliding() or $WallRay.is_colliding():
		motion.x = 0

func stopmovingidiot():
	motion.x = 0

### # HEALTHIES # ###


func take_damage(damage, playerdirection, source, knock, type):
	if type == "red":
		pass
	elif type == "yellow":
		pass
	else:
		queue_free()



### # STINKY AREAS # ###

func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_HitEmArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)
