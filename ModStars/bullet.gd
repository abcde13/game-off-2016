
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var time = 0
var dir = 1;
	
func set_dir(direction):
	if(!direction):
		dir = -1

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta

	move(Vector2(delta * 1000 * dir,0))
	if(is_colliding() || time > 0.5):
		var object_hit = get_collider()
		if(object_hit != null && object_hit.has_method("hit")):
			object_hit.hit()
		queue_free()

