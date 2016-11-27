
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var time = 0
var dir = 1;
var sprite
	
func set_dir(direction):
	if(!direction):
		dir = -1

func _ready():
	set_fixed_process(true)
	sprite = get_node("Sprite")
	
func _fixed_process(delta):
	time += delta

	move(Vector2(cos(get_rot()) * delta * 1000 * dir, sin(get_rot()) * delta * 1000 * -dir))
	if(is_colliding()):
		var object_hit = get_collider()
		if(object_hit != null):
			if(object_hit.has_method("hit")):
				object_hit.hit()
			if(!object_hit.has_method("get_name")  || object_hit.get_name() != "bullet"):
				queue_free()
	if(time > 0.5):
		queue_free()
		
func get_name():
	return "bullet"
		
		
		
		

