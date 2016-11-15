extends Area2D

func _ready():
	connect("area_enter", self, "eee")
	
func eee(who):
	print(who.overlaps_area(self))
	print(who.get_name() + "goo goo ")
	if (who.get_name() == "gun_base"):
		get_node("Sprite").set_modulate(Color(0.8, 0, 0, .5))