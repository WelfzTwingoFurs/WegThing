extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const SPEED = 150
const MAX_SPEED = 167
const KNOCKBACK = 1010
const KNOCKBACKY = -185

var motion = Vector2()
var damagearr = []

var current_speed = Vector2()
var current_acceleration = 2

enum STATES {IDLE,DEFEATED,TAKE_DAMAGE}
export(int) var state = STATES.IDLE

var clone = 0
var jumpy = 1

export var Isee = 0

var direction = 1

var lazer_projectile
func _ready():
	lazer_projectile = load("res://Entities/Enemies/CellGuy2.tscn")
	direction = randi()%2 +1
	change_state(STATES.IDLE)
	$HitEmArea/HitEmCol.disabled = false

func change_state(new_state):
	state = new_state

func _physics_process(delta):
	#jumpy = -1 
	
	current_speed.x = clamp(current_speed.x,-MAX_SPEED,MAX_SPEED)
	
	current_acceleration = lerp(current_acceleration,2+abs(current_speed.x)*0.1,0.15)
	
	motion += current_speed
	motion.x = lerp(motion.x,0,0.20)


	for body in damagearr:
		var type = "blue"
		body.take_damage(13, direction, type)



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
		STATES.TAKE_DAMAGE:
			pass

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
		if clone == 0:
			$AnimationPlayer.play("Clone")
		elif clone == 1:
			WalkFoward()
			$AnimationPlayer.play("Run")
	elif Isee == 0:
		$AnimationPlayer.play("Idle")
#		if clone == 1:
#			$AnimationPlayer.play("Delete")


func shoot():
	var lazer_instance = lazer_projectile.instance()
	lazer_instance.position = (position+Vector2(direction*20,-4))
#	lazer_instance.motion.x += 80 * direction
	lazer_instance.clone = 1
	jumpy *= -1
	lazer_instance.jumpy = jumpy
	if jumpy == 1:
		lazer_instance.motion.y += -250
		lazer_instance.motion.x = MAX_SPEED * direction
	else:
		pass
	get_parent().add_child(lazer_instance)
	$Shoot.play()


onready var player = globalls.player
onready var SeeEmCast = $SeeEmCast

### # MOVEMENT # ###

func WalkFoward():
	$HoleRay.position.x = 2.328
	
	if clone == 0:
		if $HoleRay.is_colliding():
			motion.x = (SPEED/1.3) * direction
		elif !$HoleRay.is_colliding():
			motion.x *= -1
	elif clone == 1:
		motion.x = (SPEED/1.3) * direction

func WalkBack():
	$HoleRay.position.x = -2.328
	
	if $HoleRay.is_colliding():
		motion.x = (SPEED*3) * (direction *-1)
	elif !$HoleRay.is_colliding():
		motion.x *= -1

func stopmovingidiot():
	motion.x = 0

### # HEALTHIES # ###

export(float) var max_health = 20

onready var health = max_health setget _set_health

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health :
		if health == 0:
				change_state(STATES.DEFEATED)

func take_damage(damage, playerdirection, source, knock, type):
	if clone == 1:
		queue_free()
#		$AnimationPlayer.play("Delete")
#		motion.x = 0
#		motion.y = 0
#	else:
#		if health >0:
#			if type != "yellow":
#				_set_health(health - damage)
	
	if type == "red":
		motion.y = (KNOCKBACKY)
		direction = sign((self.position.x - source.position.x)) * -1
		$AnimationPlayer.play("Ouch")
		change_state(STATES.DEFEATED)
	elif type == "yellow":
		stomped()
	else:
		motion.y += KNOCKBACKY
		motion.x = sign((self.position.x - source.position.x)) * knock
		direction = sign((self.position.x - source.position.x)) * -1
		$AnimationPlayer.play("Ouch")
		change_state(STATES.DEFEATED)
	if health <= 0:
		motion.y += KNOCKBACKY
		motion.x += sign((self.position.x - source.position.x)) * knock
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
		$AnimationPlayer.play("Bye")
	if clone == 1:
		queue_free()
	pass


### # STINKY AREAS # ###

func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)
			if clone == 1:
				queue_free()

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
	bodyinstance.slashem = true
	bodyinstance.direction = direction
	get_parent().add_child(bodyinstance)