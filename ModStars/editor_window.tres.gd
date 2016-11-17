extends  Control

var mode
var current_mode_tex
var attch
var attch_collision
var attch_area
var gun_base
var attachment = preload("res://test_area_scene.tscn")

func _ready():
	gun_base = get_node("gun/gun_base")
	gun_base.connect("input_event", gun_base, "select_attachmt")

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
			new_attachment.get_shape(0).set_extents(current_mode_tex.get_size()/2)
			get_node("gun").add_child(new_attachment)
			new_attachment.set_pickable(true)
			new_attachment.set_monitorable(true)
			new_attachment.set_enable_monitoring(true)
			new_attachment.connect("mouse_enter", gun_base, "select_attachment")
			new_attachment.translate(event.pos - new_attachment.get_parent().get_pos())
			
			if(!new_attachment.get_shape(0).collide(new_attachment.get_transform(), gun_base.get_shape(0), gun_base.get_transform())):
				new_attachment.free()
			else:
				mode = null
				#Input.set_custom_mouse_cursor(load("res://icon.png"))
				
			
				
func select_attachment(viewport, event, shape_id):
	print("selected")

				
func _on_mouse_enter():
	print("ENTERING")