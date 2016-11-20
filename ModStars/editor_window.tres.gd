extends  Control

var mode
var current_mode_tex
var gun_base
var gun
var edit_mode = null
var attachment = preload("res://test_area_scene.tscn")
var new_attachments = []
var invalid = true
var current_attachment

func _ready():
	gun = get_node("gun")
	gun_base = get_node("gun/gun_base")
	gun_base.connect("input_event", self, "select_attachment")
	set_fixed_process(true)

func _on_attachment_change(mode):
	self.mode = mode
	current_mode_tex = get_parent().get_node("attachments_window/" + mode).get_normal_texture()
	print(mode)
	
func _fixed_process(delta):
	update()
	if(current_attachment and current_attachment.get_node("Sprite")):
		do_input()
		var invalid = true	
		for child in gun.get_children():
			if (child != current_attachment):
				if(child.get_shape(0).collide(child.get_transform(), current_attachment.get_shape(0), current_attachment.get_transform())):
					invalid = false
					break
				
		if (invalid):
			current_attachment.get_node("Sprite").set_modulate(Color(1.9,0.8,0.8,1))
			self.invalid = true
		else:
			current_attachment.get_node("Sprite").set_modulate(Color(1,1,1,1))
			self.invalid = false
		
	if (invalid):
		self.invalid
	if (self.invalid):
		get_parent().get_node("attachments_window/Button").set_disabled(true)
	else:
		get_parent().get_node("attachments_window/Button").set_disabled(false)
	
func do_input():
	if (Input.is_action_pressed("SHIFT_UP")):
		if(edit_mode == "MOVE"):
			current_attachment.translate(Vector2(0,-1))
		elif(edit_mode == "ROTATE"):
			current_attachment.rotate(0.05)
		elif(edit_mode == "ZOOM"):
			gun.scale(Vector2(1.1,1.1))
	elif (Input.is_action_pressed("SHIFT_DOWN")):
		if(edit_mode == "MOVE"):
			current_attachment.translate(Vector2(0,1))
		elif(edit_mode == "ROTATE"):
			current_attachment.rotate(-0.05)
		elif(edit_mode == "ZOOM"):
			gun.scale(Vector2(0.9,0.9))
	elif (Input.is_action_pressed("SHIFT_LEFT")):
		if(edit_mode == "MOVE"):
			current_attachment.translate(Vector2(-1, 0))
		elif(edit_mode == "ROTATE"):
			current_attachment.rotate(0.05)
	elif (Input.is_action_pressed("SHIFT_RIGHT")):
		if(edit_mode == "MOVE"):
			current_attachment.translate(Vector2(1, 0))
		elif(edit_mode == "ROTATE"):
			current_attachment.rotate(-0.05)
	elif (Input.is_action_pressed("MOVE_MODE")):
		edit_mode = "MOVE"
	elif (Input.is_action_pressed("ROTATE_MODE")):
		edit_mode = "ROTATE"	
	elif (Input.is_action_pressed("ZOOM_MODE")):
		edit_mode = "ZOOM"
			
func _input_event(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and mode):
		accept_event()
		var new_attachment = create_and_place_attachment(event.pos)
		
		if(!new_attachment.get_shape(0).collide(new_attachment.get_transform(), gun_base.get_shape(0), gun_base.get_transform())):
			new_attachment.free()
		else:
			mode = null
			edit_mode = "MOVE"
			current_attachment = new_attachment
			new_attachments.append(new_attachment)
			#Input.set_custom_mouse_cursor(load("res://icon.png"))
	
func create_and_place_attachment(mouse_place):
	var new_attachment = attachment.instance()
	var attach_sprite = Sprite.new()
	attach_sprite.set_texture(current_mode_tex)
	new_attachment.add_child(attach_sprite)
	attach_sprite.set_owner(new_attachment)
	attach_sprite.set_name("Sprite")
	var shape = RectangleShape2D.new()
	shape.set_extents(current_mode_tex.get_size()/2)
	new_attachment.add_shape(shape)
	gun.add_child(new_attachment)
	new_attachment.set_owner(gun)	
	new_attachment.set_pickable(true)
	new_attachment.set_monitorable(true)
	new_attachment.set_enable_monitoring(true)
	new_attachment.connect("input_event", self, "select_attachment")
	new_attachment.translate(mouse_place - new_attachment.get_parent().get_pos())
	return new_attachment
			
				
func select_attachment(cam, event, click_pos, click_normal, shape):
	print("selected")

				
func _on_mouse_enter():
	print("ENTERING")
	
func _draw():
	VisualServer.canvas_item_set_clip(get_canvas_item(),true)
	
func next_level():
	var packed_scene = PackedScene.new()
	packed_scene.pack(gun)
	ResourceSaver.save("res://gun_new.tscn", packed_scene)
	get_tree().change_scene("res://tilemap.tscn")