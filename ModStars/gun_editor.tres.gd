extends HBoxContainer

var gun_base
var stalk_btn
var barrel_btn
var scope_btn
var mode

func _ready():
	gun_base = get_node("gun_base")
	barrel_btn = get_node("attachments_window/barrel_btn")
	scope_btn = get_node("attachments_window/scope_btn")
	stalk_btn = get_node("attachments_window/stalk_btn")
	
	barrel_btn.connect("attachment_change", self, "_on_attachment_change")
	scope_btn.connect("attachment_change", self, "_on_attachment_change")
	stalk_btn.connect("attachment_change", self, "_on_attachment_change")

	set_process(true)
	
func _input_event(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		var attch = Sprite.new()
		attch.set_texture(get_node("attachments_window/" + mode).get_normal_texture())
		attch.set_pos(event.pos)
		zadd_child(attch)
		print("HELLO")

func _on_attachment_change(mode):
	self.mode = mode
	print(mode)
	

