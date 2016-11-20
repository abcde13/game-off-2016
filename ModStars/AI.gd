
extends KinematicBody2D
const GRAVITY = 1600.0
const WALK_SPEED = 500
const JUMP_SPEED = -880
const COOLDOWN = 0.1


var velocity = Vector2()
var dir = 1
var route_time = 0
var fire_time = 0
var body_sprite
var health = 3
var jumping = true

onready var player = get_tree().get_root().get_node("Level/Player")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	body_sprite = get_node("Body")

	
func _fixed_process(delta):
	route_time += delta
	fire_time += delta
	velocity.y += delta * GRAVITY
	if(check_sight()):
		hunt_player()
	else:
		route(delta)
	motion(delta)
	
func route(delta):
	if(route_time > 1):
		dir = -dir
		body_sprite.scale(Vector2(-1,1))
		route_time = 0
	velocity.x = WALK_SPEED * dir
	
func motion(delta):
	var motion = velocity * delta
	motion = move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		if(get_global_pos().y - get_collision_pos().y < -40):
			jumping = false;
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

func hit():
	health = health-1;
	if(health <= 0):
		queue_free()
		
func check_sight():
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray( get_global_pos(), player.get_global_pos(), [ self ] )
	return(not result.empty() && result.collider == player)
		

func hunt_player():
	var dist_to_player_x = player.get_global_pos().x - get_global_pos().x
	var dist_to_player_y = player.get_global_pos().y - get_global_pos().y
	if(dist_to_player_x > 0):
		dir = 1
		body_sprite.set_scale(Vector2(1,1))
	else:
		dir = -1
		body_sprite.set_scale(Vector2(-1,1))
		
	if(abs(dist_to_player_x) > 300):
		velocity.x = WALK_SPEED * dir
	else:
		velocity.x = 0
		
	if(dist_to_player_y < -100 && !jumping):
		print(dist_to_player_y)
		velocity.y = JUMP_SPEED
		jumping = true
	
	if(abs(dist_to_player_y) < 40 && fire_time > COOLDOWN):
		fire_time = 0
		print("FIRE")
		
		
	
		
