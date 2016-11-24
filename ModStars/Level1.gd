
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var level_number;
var ai_count;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ai_count = get_node("AI_Group").get_child_count()
	set_process(true);
	
func _process(delta):
	
	ai_count = get_node("AI_Group").get_child_count()
	
	if(ai_count == 0):
		get_tree().change_scene("gun_editor.tscn")


