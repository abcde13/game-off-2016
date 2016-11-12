extends TextureButton

signal attachment_change

func _pressed():
	Input.set_custom_mouse_cursor(self.get_normal_texture())
	emit_signal("attachment_change", self.get_name())