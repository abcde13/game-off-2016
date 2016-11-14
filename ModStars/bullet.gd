
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var time = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta
	move(Vector2(delta * 1000,0))
	if(is_colliding() || time > 0.5):
		print("colliding")
		free()

