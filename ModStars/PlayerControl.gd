
extends KinematicBody2D
const GRAVITY = 1600.0
const WALK_SPEED = 500
const JUMP_SPEED = -880
const COOLDOWN = 0.1

var velocity = Vector2()

var jumping = false

var player_node
var player_animation
var time = 0;
var idle = false
var bullet = preload("res://Bullet.tscn")
var debounce_fire = 0
var cooldown_timer = 0;
var facing_right = true;

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
				var b = bullet.instance()
				b.set_dir(facing_right)
				var pos = get_global_pos()
				b.set_pos(pos)
				if(facing_right):
					b.move_local_x(100)
				else:
					b.move_local_x(-100)
				get_parent().add_child(b)
				debounce_fire = 0
				cooldown_timer = 0
		
	if(velocity.x != 0 || jumping):
		idle = false
		if(player_animation.get_current_animation() == "Idle"):
			player_animation.play("Rest")
		else:
			idle = true
	
	var motion = velocity * delta
	motion = move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
		jumping = false;



func _ready():
	set_fixed_process(true)
	player_node = get_node("Player")
	player_animation = get_node("Player/AnimationPlayer")


