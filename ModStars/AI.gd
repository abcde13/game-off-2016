
extends KinematicBody2D
const GRAVITY = 1600.0
const WALK_SPEED = 500
const JUMP_SPEED = -880
const COOLDOWN = 1


var velocity = Vector2()
var dir = 1
var route_time = 0
var body_sprite
var health = 3
var jumping = true
var gun = true
var fire_time = 0
var facing_right = true
var bullet = preload("res://Bullet.tscn")
var barrel = preload("res://barrel.gd")
var flash = preload("res://MuzzleFlash.tex")
var flashes = []


onready var player = get_tree().get_root().get_node("Level/Player")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	body_sprite = get_node("Body")
	gun = load("res://gun_old.tscn").instance()
	body_sprite.add_child(gun)
	gun.set_pos(Vector2(0,0))
	gun.translate(Vector2(80,0))
	gun.scale(Vector2(.5,.5))
	

	
func _fixed_process(delta):
	for f in flashes:
		get_parent().remove_child(f)
		flashes.remove(flashes.find(f))
	
	route_time += delta
	fire_time += delta
	velocity.y += delta * GRAVITY
	if(get_global_pos().y > 400):
		hit()
	if(player and !player.is_queued_for_deletion()):
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
		facing_right = true
		body_sprite.set_scale(Vector2(1,1))
	else:
		dir = -1
		facing_right = false
		body_sprite.set_scale(Vector2(-1,1))
		
	if(abs(dist_to_player_x) > 300):
		velocity.x = WALK_SPEED * dir
	else:
		velocity.x = 0
		
	if(dist_to_player_y < -100 && !jumping):
		print(dist_to_player_y)
		velocity.y = JUMP_SPEED
		jumping = true
	
	if(abs(dist_to_player_x) < 1000 && fire_time > COOLDOWN):
		fire_time = 0
		fire()
		
		
func fire():
	for brl in gun.get_children():
		if (brl extends barrel):
			var b = bullet.instance()
			
			b.set_dir(facing_right)
			
			var pos = brl.get_global_pos()
			
			var muzzle_flash = Sprite.new()
			muzzle_flash.set_texture(flash)
			muzzle_flash.scale(Vector2(.4,.4)) 
			muzzle_flash.set_modulate(Color(.3,1,1.3))
			
			get_parent().add_child(b)
			get_parent().add_child(muzzle_flash)
			if(dir == 1):
				muzzle_flash.set_rot(brl.get_rot())
				muzzle_flash.set_pos(Vector2(pos[0] + cos(muzzle_flash.get_rot()) * 70, pos[1] + sin(muzzle_flash.get_rot())*-70))
				
				b.set_rot(brl.get_rot())
				b.set_pos(Vector2(pos[0] + cos(b.get_rot()) * 100, pos[1] + sin(b.get_rot())*-100))
			else:
				muzzle_flash.set_rot(2*PI - brl.get_rot())
				muzzle_flash.scale(Vector2(-1,1))
				muzzle_flash.set_pos(Vector2(pos[0] + cos(muzzle_flash.get_rot()) * -70, pos[1] + sin(muzzle_flash.get_rot())*70))
				
				b.set_rot(2*PI - brl.get_rot())
				b.scale(Vector2(-1,1))
				b.set_pos(Vector2(pos[0] + cos(b.get_rot()) * -100, pos[1] + sin(b.get_rot())*100))
			#get_parent().add_child(b)
			flashes.push_back(muzzle_flash)
	
	
		
