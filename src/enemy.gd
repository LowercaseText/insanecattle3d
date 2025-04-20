extends VehicleBody3D


func _physics_process(delta):
	var left = $detect_left.is_colliding()
	var right = $detect_right.is_colliding()
	var charge = $detect_ahead.is_colliding()
	var cright = $detect_cright.is_colliding()
	var cleft = $detect_cleft.is_colliding()

	if charge == true:
		steering = 0
		engine_force = 200
	elif cleft == true:
		steering = 18
		engine_force = 300
	elif cright == true:
		steering = -18
		engine_force = 300
	elif left == true:
		steering = 3
		engine_force = 70
	elif right == true:
		steering = -3
		engine_force = 70
	else:
		steering = 0
		engine_force = 100
		

func _on_tree_entered() -> void:
	pass # Replace with function body.
