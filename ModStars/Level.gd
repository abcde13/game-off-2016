
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var ai_count;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	ai_count = get_node("AI_Group").get_child_count()
	set_process(true);
	
	
func _process(delta):
	
	ai_count = get_node("AI_Group").get_child_count()
	
	if(!has_node("Player")):
		get_tree().change_scene("res://game_over.tscn")
	
	if(ai_count == 0):
		global.level = global.level+1
		if (global.level > 5):
			get_tree.change_scene("res://win.tscn")
		else:
			get_tree().change_scene("res://gun_editor.tscn")


