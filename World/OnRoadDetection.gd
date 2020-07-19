extends Area2D
#Signal the player when he enter the area


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		get_node("/root/World/YSort/Player").isOnRoad = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		get_node("/root/World/YSort/Player").isOnRoad = false
		
