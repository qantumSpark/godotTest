extends Node2D

#Ressource
onready var animatedSprite = $AnimatedSprite


func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animated")
	
# When finish, delete the instance of scene
func _on_AnimatedSprite_animation_finished():
	queue_free()
