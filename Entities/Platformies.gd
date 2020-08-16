extends Node2D

var wherehim = 0
var dumbass = 0

func _ready():
	set_as_toplevel(true)
	wherehim = 0

func _physics_process(delta):

	if dumbass == 1:
		$"1/PlayArea1/PlayCol".disabled = true
		$"2/PlayArea2/PlayCol".disabled = true
		$"3/PlayArea3/PlayCol".disabled = true
		$"4/PlayArea4/PlayCol".disabled = true
		$"5/PlayArea5/PlayCol".disabled = true
		$"6/PlayArea6/PlayCol".disabled = true

	if $Timer.is_stopped():
		wherehim = 0
		$AnimationPlayer.play("0")


##DEATH##

const kaboom = preload("res://Entities/Effects/Explod.tscn")
func kaboom1():
	$"1/BoomArea/BoomCol".disabled = false
	$"1/CollisionShape2D".disabled = true
	$"1".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"1".global_position)
	get_parent().add_child(kaboominstance)

func kaboom2():
	$"2/BoomArea/BoomCol".disabled = false
	$"2/CollisionShape2D".disabled = true
	$"2".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"2".global_position)
	get_parent().add_child(kaboominstance)

func kaboom3():
	$"3/BoomArea/BoomCol".disabled = false
	$"3/CollisionShape2D".disabled = true
	$"3".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"3".global_position)
	get_parent().add_child(kaboominstance)

func kaboom4():
	$"4/BoomArea/BoomCol".disabled = false
	$"4/CollisionShape2D".disabled = true
	$"4".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"4".global_position)
	get_parent().add_child(kaboominstance)

func kaboom5():
	$"5/BoomArea/BoomCol".disabled = false
	$"5/CollisionShape2D".disabled = true
	$"5".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"5".global_position)
	get_parent().add_child(kaboominstance)

func kaboom6():
	$"6/BoomArea/BoomCol".disabled = false
	$"6/CollisionShape2D".disabled = true
	$"6".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"6".global_position)
	get_parent().add_child(kaboominstance)

func kaboom7():
	$"7/BoomArea/BoomCol".disabled = false
	$"7/CollisionShape2D".disabled = true
	$"7".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"7".global_position)
	get_parent().add_child(kaboominstance)

func kaboom8():
	$"8/BoomArea/BoomCol".disabled = false
	$"8/CollisionShape2D".disabled = true
	$"8".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"8".global_position)
	get_parent().add_child(kaboominstance)

func kaboom9():
	$"9/BoomArea/BoomCol".disabled = false
	$"9/CollisionShape2D".disabled = true
	$"9".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"9".global_position)
	get_parent().add_child(kaboominstance)

func kaboom10():
	$"10/BoomArea/BoomCol".disabled = false
	$"10/CollisionShape2D".disabled = true
	$"10".visible = false
	var kaboominstance = kaboom.instance()
	kaboominstance.set_as_toplevel(true)
	kaboominstance.position = ($"10".global_position)
	get_parent().add_child(kaboominstance)

##WHERE IS HIM##

func _on_PlayArea_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 1 or wherehim == 2:
			wherehim = 1
			#$Timer.start()
			$AnimationPlayer.play("1")
		else:
			dumbass = 1
			wherehim = 1
			$AnimationPlayer.play("a1kaboom")

func _on_PlayArea2_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 2 or wherehim == 1 or wherehim == 3:
			wherehim = 2
			#$Timer.start()
			$AnimationPlayer.play("2")
		else:
			dumbass = 1
			wherehim = 2
			$AnimationPlayer.play("a2kaboom")

func _on_PlayArea3_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 3 or wherehim == 2 or wherehim == 4:
			wherehim = 3
			#$Timer.start()
			$AnimationPlayer.play("3")
		else:
			dumbass = 1
			wherehim = 3
			$AnimationPlayer.play("a3kaboom")

func _on_PlayArea4_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 4 or wherehim == 3 or wherehim == 5:
			wherehim = 4
			#$Timer.start()
			$AnimationPlayer.play("4")
		else:
			dumbass = 1
			wherehim = 4
			$AnimationPlayer.play("a4kaboom")

func _on_PlayArea5_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 5 or wherehim == 4 or wherehim == 6:
			wherehim = 5
			#$Timer.start()
			$AnimationPlayer.play("5")
		else:
			dumbass = 1
			wherehim = 5
			$AnimationPlayer.play("a5kaboom")

func _on_PlayArea6_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 6 or wherehim == 5 or wherehim == 7:
			wherehim = 6
			#$Timer.start()
			$AnimationPlayer.play("6")
		else:
			dumbass = 1
			wherehim = 6
			$AnimationPlayer.play("a6kaboom")

func _on_PlayArea7_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 7 or wherehim == 6 or wherehim == 8:
			wherehim = 7
			#$Timer.start()
			$AnimationPlayer.play("7")
		else:
			dumbass = 1
			wherehim = 7
			$AnimationPlayer.play("a7kaboom")


func _on_PlayArea8_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 8 or wherehim == 7 or wherehim == 9:
			wherehim = 8
			#$Timer.start()
			$AnimationPlayer.play("8")
		else:
			dumbass = 1
			wherehim = 8
			$AnimationPlayer.play("a8kaboom")


func _on_PlayArea9_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 9 or wherehim == 8 or wherehim == 10:
			wherehim = 9
			#$Timer.start()
			$AnimationPlayer.play("9")
		else:
			dumbass = 1
			wherehim = 9
			$AnimationPlayer.play("a9kaboom")


func _on_PlayArea10_body_entered(body):
	if body.is_in_group("player"):
		if wherehim == 0 or wherehim == 10 or wherehim == 9:
			wherehim = 10
			#$Timer.start()
			$AnimationPlayer.play("10")
		else:
			dumbass = 1
			wherehim = 10
			$AnimationPlayer.play("a10kaboom")

func ImTooLazyToAddTwoMethodTracksOnAnimationPlayerSoIllJustMakeAFunctionThatPlaysTwoSoundEffectsAndNothingElse():
	$lightswitch2.play()
	$bell1.play()

func _on_BoomArea_body_entered(body):
	if body.is_in_group("player"):
		var type = "blue"
		var direction = 0
		body.take_damage(20, direction, type)


func _on_PlayArea1_body_exited(body):
	$Timer.start()

func _on_PlayArea2_body_exited(body):
	$Timer.start()

func _on_PlayArea3_body_exited(body):
	$Timer.start()

func _on_PlayArea4_body_exited(body):
	$Timer.start()

func _on_PlayArea5_body_exited(body):
	$Timer.start()

func _on_PlayArea6_body_exited(body):
	$Timer.start()

func _on_PlayArea7_body_exited(body):
	$Timer.start()

func _on_PlayArea8_body_exited(body):
	$Timer.start()

func _on_PlayArea9_body_exited(body):
	$Timer.start()

func _on_PlayArea10_body_exited(body):
	$Timer.start()
