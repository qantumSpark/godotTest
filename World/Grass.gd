extends Node2D

# Spawn instance of animation + delete grassObject
func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()

# Manage animation
func create_grass_effect():
	# Get Animation Sprite scene
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	
	# Spawn an instance  in the current scene
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	
	# Position the animation
	grassEffect.global_position = global_position


