extends Area2D

func _ready():
	connect("area_enter", self, "eee")
	
func eee(who):
	print(who.overlaps_area(self))
