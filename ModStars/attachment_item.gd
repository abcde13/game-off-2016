# Used for all attachment types right now. 

extends TextureButton

signal attachment_change

func _ready():
	self.connect("attachment_change", get_parent().get_parent().get_node("editor_window"), "_on_attachment_change")

func _pressed():
	Input.set_custom_mouse_cursor(self.get_normal_texture())
	emit_signal("attachment_change", self.get_name())
	
	