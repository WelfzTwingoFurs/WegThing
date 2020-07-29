extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const ACCELERATION = 50
const MAX_SPEED = 150
const JUMP_HEIGHT = -330

var motion = Vector2()

func _process(delta):
	motion.y += GRAVITY
	var friction = false
	var kickingmed = false
	var kickinghi = false
	var kickingduck = false
	
	if Input.is_action_just_pressed("ui_page_down") && $Sprite.animation != "Duckin'" && !kickingmed && !kickinghi && !kickingduck:
		kickingmed = true
		motion = Vector2(0, 0)
	if kickingmed:
		$Sprite.play("Kickin'MED")
		$KicolMed.disabled = false
	if kickingmed && $Sprite.frame == 4:
		kickingmed = false
		$KicolMed.disabled = true
	
	if !kickingmed:
		$KicolMed.disabled = true
		if Input.is_action_pressed("ui_right"):
			$Ducol.disabled = false
			$Recolar.disabled = true
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			$Sprite.flip_h = false
			if is_on_floor():
				$Sprite.play ("Fastin'")
	
		elif Input.is_action_pressed("ui_left"):
			$Ducol.disabled = false
			$Recolar.disabled = true
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			$Sprite.flip_h = true
			if is_on_floor():
				$Sprite.play ("Fastin'")
		else:
				friction = true
				$Ducol.disabled = false
				$Recolar.disabled = true
				if is_on_floor():
					$Sprite.play ("Idlin'")
	
	if Input.is_action_pressed("ui_down"):
		if is_on_floor() && !kickingmed:
			$Sprite.play ("Duckin'")
		if friction:
			motion.x = lerp(motion.x, 0, 1)
	
	if is_on_floor():
		$Ducol.disabled = false
		$Recolar.disabled = true
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction == true:
				motion.x = lerp(motion.x, 0, 0.2)
	else: 
		$Ducol.disabled = false
		$Recolar.disabled = true
		if motion.y < 0:
			$Sprite.play ("Highin'")
		else:
			$Ducol.disabled = false
			$Recolar.disabled = true
			$Sprite.play ("Downin'")
		if friction == true:
				motion.x = lerp(motion.x, 0, 0.5)
	
	if $Sprite.animation != "Duckin'":
		$Ducol.disabled = true
		$Recolar.disabled = false
		
	
	if !$Sprite.flip_h:
		$KicolHi.position.x = 7
		$KicolMed.position.x = 15
		$KicolDuck.position.x = 13
	
	if $Sprite.flip_h:
		$KicolHi.position.x = -7
		$KicolMed.position.x = -15
		$KicolDuck.position.x = -13
	
	motion = move_and_slide(motion, UP)
	
	pass

func _on_Sprite_animation_finished():
	var kickingmed = false
	var kickinghi = false
	var kickingduck = false
	
	kickingmed = false
	
	
	
	pass # Replace with function body.
