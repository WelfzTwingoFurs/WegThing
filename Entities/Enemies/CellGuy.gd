extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 80
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var motion = Vector2()
var damagearr = []

enum STATES {IDLE,DEFEATED}
export(int) var state = STATES.IDLE

export var Isee = 0

var direction = 1

var lazer_projectile
func _ready():
	lazer_projectile = load("res://Entities/Enemies/CellGuyClone.tscn")
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
		STATES.DEFEATED:
			dead()

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y

	var WindowX = globalls.WindowX
	var WindowY = globalls.WindowY

	if abs(playerXdistance) < (WindowX/4):
		if abs(playerYdistance) < (WindowY/4):
			SeeEmCast.cast_to = player.position - position
		else:
			Isee = 0
	else:
		Isee = 0

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


func shoot():
	var lazer_instance = lazer_projectile.instance()
	lazer_instance.position = (position+Vector2(direction*10,-4))
	lazer_instance.motion.x += 80 * direction
	lazer_instance.motion.y += -200
	get_parent().add_child(lazer_instance)
	$Shoot.play()


onready var player = globalls.player
onready var SeeEmCast = $SeeEmCast

### # MOVEMENT # ###

func WalkFoward():
	$HoleRay.position.x = 2.328
	
	if $HoleRay.is_colliding():
		motion.x = SPEED# * direction
	elif !$HoleRay.is_colliding():
		motion.x *= -1

func WalkBack():
	$HoleRay.position.x = -2.328
	
	if $HoleRay.is_colliding():
		motion.x = -SPEED# * direction
	elif !$HoleRay.is_colliding():
		motion.x *= -1

func stopmovingidiot():
	motion.x = 0

### # HEALTHIES # ###


func take_damage(damage, playerdirection, source, knock, type):
	if type == "red":
		motion.y = (KNOCKBACKY)
		direction = sign((self.position.x - source.position.x)) * -1
		kaboom()
		change_state(STATES.DEFEATED)
	elif type == "yellow":
		stomped()
	else:
		motion.y = (KNOCKBACKY)
		motion.x = sign((self.position.x - source.position.x)) * knock
		direction = sign((self.position.x - source.position.x)) * -1
		kaboom()
		change_state(STATES.DEFEATED)


func stomped():
	$AnimationPlayer.play("Stomped")
	motion.y = 0
	motion.x = 0
	$HitEmArea/HitEmCol.disabled = true

func dead():
	$AnimationPlayer.play("Bye2")
	if is_on_floor():
		body()
		queue_free()
	pass


### # STINKY AREAS # ###

func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_HitEmArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)

const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	var kaboominstance = kaboom.instance()
	kaboominstance.position = (position+Vector2(0,18))
	get_parent().add_child(kaboominstance)

const item = preload("res://Entities/Items/ItemDropped.tscn")
func item():
	pass

const body = preload("res://Entities/Body.tscn")
func body():
	var bodyinstance = body.instance()
	bodyinstance.position = (position+Vector2(0,15))
	bodyinstance.shootya = true
	bodyinstance.direction = direction
	get_parent().add_child(bodyinstance)