extends KinematicBody2D
var Lazer = preload("res://Entities/Projectiles/lazer.tscn")

enum STATES {ACTIVE, DEAD}
var current_state = STATES.ACTIVE
var GRAVITY = 12
var health = 10
var knockback = 10
var lazer_velocity = 100
var direction = 1
export var turning = 0

var contact_damage = 8
var damagearr = []
var seearr = []
var player_direction = -1

onready var ShootTimer = $ShootTimer
onready var ray:=$Pointer/RayCast2D
var dead = 0
var stun = 0
export var ready2shoot = 0

var hit_pos

const lazer_projectile = preload("res://Entities/Enemies/HeatSeek.tscn")
var motion = Vector2(0,0)
#crude way to access the player: if the player does not exist for whatever reason this code will crash the game
onready var player = globalls.player

func shoot_lazer():
	# create instance of lazer
	var lazer_instance = lazer_projectile.instance()
	# set lazer's speed and direction to lazer_velocity and the direction of the turret
#	lazer_instance.direction.x = direction
#	lazer_instance.speed = 299
	# position the lazer over the turret so that it looks like it's coming out of the muzzle
	if direction == -1:
		lazer_instance.position = (position+Vector2(direction*10,+6))
	elif direction == 1:
		lazer_instance.position = (position+Vector2(direction*10,+7))
	# set knockback power of lazer
#	lazer_instance.knockback = 9
	# add the lazer to the scene
	get_parent().add_child(lazer_instance)
	lazer_instance.get_node("AnimationPlayer").play("reallynotboomies")
	$ShootSound.play()
	


func _physics_process(delta):
	motion.y += GRAVITY
	update()


	if current_state == STATES.ACTIVE:
		if ray.is_colliding():
			var body = ray.get_collider()
			if body.is_in_group("player"):
				if ShootTimer.is_stopped():
					if turning == 0:
						if direction == 1:
							$AnimationPlayer.play("shootBack")
						if direction == -1:
							$AnimationPlayer.play("shootFront")
						#shoot_lazer()
						ShootTimer.start()

	var playerXdistance = position.x - player.position.x
	var playerYdistance = position.y - player.position.y
	var WindowX = globalls.WindowX
	var WindowY = globalls.WindowY

	if abs(playerXdistance) < (WindowX/4):
		if abs(playerYdistance) < (WindowY/4):
			ray.cast_to = player.position - position

		move_and_slide(Vector2(0,0))
	# turning and shooting code
		# get whether the player is to the left or the right of the turret
		var player_direction = sign(player.position.x - position.x)
		
		# if not already facing in the direction of the player
		if player_direction != direction:
			# if player is to the left, play the animation to turn left
			if player_direction == -1:
				if turning == 0:
					$AnimationPlayer.play("turnfront")
					ray.position.x = 0
					ray.position.y = 8
			# if the player is to the right, play the animation to turn right
			elif player_direction == 1:
				if turning == 0:
					$AnimationPlayer.play("turnback")
					ray.position.x = 0
					ray.position.y = 4



		# deal contact damage
		for body in damagearr:
			var type = "blue"
			body.take_damage(contact_damage, direction, type)
		
		if health <= 0:
			direction = player_direction
			dead = 1
			$AnimationPlayer.play("Dead2")
			#$Die.play()
			$Shape.disabled = true
			current_state = STATES.DEAD

	# if dead
	elif current_state == STATES.DEAD:
		direction = player_direction




func _draw():
	if current_state == STATES.ACTIVE:
		if turning == 0:
			draw_line(Vector2(-5,ray.position.y), (ray.get_collision_point() - position), Color8(0, 255, 0)/2, 1)
			if ray.is_colliding():
				var body = ray.get_collider()
				if body.is_in_group("player"):
					draw_line(Vector2(-5,ray.position.y), (ray.get_collision_point() - position), Color8(0, 255, 0), 1)



# taking damage code
func take_damage(damage, dir, source, knock, type):
	health -= damage
	$Hurt.play()
	$Die.play()
	if type == "yellow":
		$AnimationPlayer.play("Stun")
		motion.y = 0
	else:
		if turning == 0:
			$AnimationPlayer.play("Hit")

# standard contact damage tracking code
func _on_HitEmArea_body_entered(body):
	if body.is_in_group("player"):
		if !damagearr.has(body):
			damagearr.push_back(body)

func _on_HitEmArea_body_exited(body):
	if body.is_in_group("player"):
		if damagearr.has(body):
			damagearr.erase(body)


const body = preload("res://Entities/Body.tscn")
func body():
	var bodyinstance = body.instance()
	bodyinstance.position = (position+Vector2(0,15))
	bodyinstance.turret = true
	bodyinstance.direction = direction
	get_parent().add_child(bodyinstance)

const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom():
	var kaboominstance = kaboom.instance()
	kaboominstance.position = (position+Vector2(0,18))
	get_parent().add_child(kaboominstance)

const item = preload("res://Entities/Items/ItemDropped.tscn")
func item():
	var iteminstance = item.instance()
	iteminstance.position = (position+Vector2(0,15))
	iteminstance.direction = direction
	iteminstance.whoamI = "2turret"
	get_parent().add_child(iteminstance)
	
