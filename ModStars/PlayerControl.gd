
extends KinematicBody2D
const GRAVITY = 1600.0
const WALK_SPEED = 500
const JUMP_SPEED = -880
const COOLDOWN = 0.1

var velocity = Vector2()

var jumping = false

var player_node
var player_animation
var time = 0
var idle = true
var bullet = preload("res://Bullet.tscn")
var barrel = preload("res://barrel.gd")
var debounce_fire = 0
var cooldown_timer = 0
var facing_right = true
var health = 5
var gun

func _fixed_process(delta):
	cooldown_timer += delta
	if(time > 2 && idle):
		player_animation.play("Idle")
		time = 0
	else:
		time += delta
		velocity.y += delta * GRAVITY
		velocity.x = 0
	if (Input.is_action_pressed("btn_left")):
		velocity.x = - WALK_SPEED
		if (facing_right):
			facing_right = false;
			player_node.set_scale(Vector2(-1,1))
	if (Input.is_action_pressed("btn_right")):
		velocity.x =   WALK_SPEED
		if (!facing_right):
			facing_right = true;
			player_node.set_scale(Vector2(1,1))

	if (Input.is_action_pressed("jump") && not jumping):
		velocity.y = JUMP_SPEED
		jumping = true
	if (Input.is_action_pressed("fire")):
		if(cooldown_timer > COOLDOWN):
			debounce_fire += 1
			if(debounce_fire == 6):
				for brl in gun.get_children():
					if (brl extends barrel):
						var b = bullet.instance()
						
						b.set_dir(facing_right)
						
						var pos = brl.get_global_pos()
						print(b.get_rot())
						print(cos(b.get_rot())* 100)
						print(sin(b.get_rot()) * 100)
						get_parent().add_child(b)
						if(facing_right):
							b.set_rot(brl.get_rot())
							b.set_pos(Vector2(pos[0] + cos(b.get_rot()) * 120, pos[1] + sin(b.get_rot())*-120))
						else:
							b.set_rot(2*PI - brl.get_rot())
							b.scale(Vector2(-1,1))
							b.set_pos(Vector2(pos[0] + cos(b.get_rot()) * -120, pos[1] + sin(b.get_rot())*120))
						#get_parent().add_child(b)
						debounce_fire = 0
						cooldown_timer = 0
		
	if(velocity.x != 0 || jumping):
		idle = false
		if(player_animation.get_current_animation() == "Idle" || player_animation.get_current_animation() == "Rest"):
			player_animation.play("run")
		else:
			idle = true
	elif (velocity.x == 0): 
		if(player_animation.get_current_animation() != "Idle"):
			player_animation.play("Rest")
	var motion = velocity * delta
	motion = move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		if(get_global_pos().y - get_collision_pos().y < -40):
			jumping = false;
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
		



func _ready():
	set_fixed_process(true)
	player_node = get_node("Player")
	gun = load("res://gun_new.tscn").instance()
	player_node.add_child(gun)
	gun.set_pos(Vector2(0,0))
	gun.translate(Vector2(80,0))
	gun.scale(Vector2(1,1))
	player_animation = get_node("Player/AnimationPlayer")

func hit():
	health = health-1;
	if(health <= 0):
		queue_free()
	

func get_name():
	return "player"