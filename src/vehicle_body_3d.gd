extends VehicleBody3D

var isdead = false
var iswinstate = false

var boost = 1
var energy = 100

var onground = true

func bleat():
	$Bleat.pitch_scale = randf_range(0.7, 1.3)
	$Bleat.play()


func freeCam():
	$Node / Camera3D3 / AudioListener3D.make_current()
	$Node / Camera3D3.make_current()

func hop(strength):
	if (position.y < 0.20): 
		linear_velocity.y += 5 * strength
	#await get_tree().create_timer(1).timeout
	

func unlockshit():
	if Global.currentlevel == "ireland":
		if Global.unlockedlevels == 1:
			Global.beatenlevels = 1
			Global.unlockedlevels = 2
	elif Global.currentlevel == "egypt":
		if Global.unlockedlevels == 2:
			Global.beatenlevels = 2
			Global.unlockedlevels = 3
	elif Global.currentlevel == "sweden":
		if Global.unlockedlevels == 3:
			Global.beatenlevels = 3
			Global.unlockedlevels = 4

func win():
	$Node / Camera3D3 / freecamlisten / Crowd.play()
	$detect_dead / RichTextLabel5.show()
	$detect_dead / quitw .show()
	freeCam()
	unlockshit()
	saveprogress()
	iswinstate = true
	print("You win!")

func saveprogress():
	var data = SaveData.new()
	data.saveunlockedlevels = Global.unlockedlevels
	data.beatenlevels = Global.beatenlevels
	data.savename = Global.playername
	data.mastervol = AudioServer.get_bus_volume_db(0)
	data.musicvol = AudioServer.get_bus_volume_db(1)
	if DisplayServer.window_get_mode() == (DisplayServer.WINDOW_MODE_FULLSCREEN):
		data.fullscreen = true
	else:
		data.fullscreen = false
	print("Saved")
	ResourceSaver.save(data, "user://savefile.tres")

func _input(event):
	if event.is_action_pressed("horn"):
		bleat()
		if isdead == true and iswinstate == false:
				Global.global_sheep = 0
				Global.sheepnum = 0
				Global.eliminated = ""
				get_tree().reload_current_scene()
		elif iswinstate == true:
			get_tree().change_scene_to_file("res://worldmap.tscn")
	if event.is_action_released("horn"):
		$Bleat.stop()
	if event.is_action_pressed("debug_win"):
		win()
	if event.is_action_pressed("hop"):
		hop(1)


var doamovespeed = 100
var won = false


func _physics_process(delta):
	var dead = $detect_dead.is_colliding()
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	engine_force = Input.get_axis("back", "forward") * doamovespeed * boost
	if (position.y > 0.20):
		#rotate_z(Input.get_axis("back", "forward") * 5 * delta)
		rotate_y(Input.get_axis("left", "right") * 5 * delta)
	if isdead == false:
		if dead == true and iswinstate == false:
			print("DEAD")
			doamovespeed = 0
			Global.eliminated = "[pulse]" + Global.playername + " has been eliminated."
			$detect_dead / RichTextLabel2.show()
			$detect_dead / restart.show()
			freeCam()
			$sheep.queue_free()
			$CollisionShape3D.queue_free()
			$Node / Camera3D3 / freecamlisten / Explode.play()
			$Node / Camera3D3 / freecamlisten / explosion.play()
			isdead = true
	if dead == false and Global.global_sheep == 0:
		if won == false:
			win()
			won = true


func _on_restart_pressed() -> void:
	$detect_dead/Uirelease.play()
	Global.global_sheep = 0
	Global.sheepnum = 0
	Global.eliminated = ""
	
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	$detect_dead/Uirelease.play()
	Global.global_sheep = 0
	Global.sheepnum = 0
	Global.eliminated = ""
	get_tree().change_scene_to_file("res://menu.tscn")
