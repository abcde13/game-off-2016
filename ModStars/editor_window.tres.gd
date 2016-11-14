extends PanelContainer

var mode
var current_mode_tex

func _ready():
	get_node("gun/gun_base").add_shape(

func _test_gun_overlap(new_piece):
	var gun_base_area = get_node("gun_base_area")
	print(gun_base_area.show())
	print(new_piece.show())
	print(gun_base_area.overlaps_body(new_piece))
	gun_base_area.overlaps_area(new_piece)

func _on_attachment_change(mode):
	self.mode = mode
	current_mode_tex = get_parent().get_node("attachments_window/" + mode).get_normal_texture()
	print(mode)
	
func _input_event(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		if (mode):
			var attch = Sprite.new()
			attch.set_texture(current_mode_tex)
			var attch_area = Area2D.new()
			attch_area.add_child(attch)
			attch_area.set_pos(event.pos)
			add_child(attch_area)
			if (!_test_gun_overlap(attch_area)):
				attch_area.free()
				print("HELLO")