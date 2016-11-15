extends  Control

var mode
var current_mode_tex
var attch
var attch_collision
var attch_area
var gun_base
var attachment = preload("res://test_area_scene.tscn")

func _ready():
	gun_base = get_node("gun_base")
	set_process(true)
	
func _process(delta):
	update()

func _test_gun_overlap(new_piece):
	print(gun_base.get_overlapping_areas())
	return new_piece.overlaps_area(gun_base)
	

func _on_attachment_change(mode):
	self.mode = mode
	current_mode_tex = get_parent().get_node("attachments_window/" + mode).get_normal_texture()
	print(mode)
	
func _input_event(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		accept_event()
		if (mode):
			var new_attachment = attachment.instance()
			new_attachment.get_node("Sprite").set_texture(current_mode_tex)
			var shape = RectangleShape2D.new()
			shape.set_extents(current_mode_tex.get_size()/2)
			new_attachment.add_shape(shape)
			new_attachment.translate(event.pos)
			

		
			add_child(new_attachment)
			if(!new_attachment.get_shape(0).collide(new_attachment.get_transform(), gun_base.get_shape(0), gun_base.get_transform())):
				new_attachment.free()
			
				

				
func _on_mouse_enter():
	print("ENTERING")