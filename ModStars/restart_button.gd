
extends MenuButton

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _pressed():
	var dir = Directory.new()
	dir.remove("res://gun_old.tscn")
	dir.remove("res://gun_new.tscn")
	global.level = 1
	get_tree().change_scene("res://gun_editor.tscn")