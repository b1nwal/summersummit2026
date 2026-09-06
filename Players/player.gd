
class_name Player 
extends CharacterBody2D

@onready var speed = get_meta("speed")
@onready var animated_sprite = $Sprite2D
@onready var interaction_range = $InteractionRange

signal score_earned(amount)

var run_start
var stop_start
var exit_point
var holding_item = null
var running = false
var ramp_up = 300
var ramp_down = 410
var facing := Vector2.RIGHT
var f_stiffness = 0.02352
var f_damping = 0.154
var f_A = .07
var angular_velocity = 0
var angular_acceleration = 0
var checked = 0
var record = [Vector2()]

func _unhandled_input(event):
	if get_script() != Player:
		return

	if event.is_action_pressed("interact"):
		if !holding_item:
			interact_with_closest_artifacts()

func _obtain_v_vec():
	var a = Input.get_vector("move_left","move_right","move_up","move_down")
	record.append(a)
	return a

func _physics_process(delta: float) -> void:
	# movement
	physics_handle_movement()
	physics_handle_flashlight()
	move_and_slide()
	
	# check if distance to exit is < 64 px
	if global_position.distance_squared_to(exit_point) < 4096:
		on_exit_point_reached()

func physics_handle_movement():
	var v_vec = _obtain_v_vec()

	if v_vec[0] > 0:
		animated_sprite.play("walk_right")
	elif v_vec[0] < 0:
		animated_sprite.play("walk_left")
	elif v_vec[1] > 0:
		animated_sprite.play("walk_forward")
	elif v_vec[1] < 0:
		animated_sprite.play("walk_backward")
		 
	var e = angle_difference(v_vec.angle(), facing.angle())

	if not v_vec == Vector2.ZERO and not running:
		running = true
		run_start = Time.get_ticks_msec()
	if v_vec == Vector2.ZERO and running:
		running = false
		stop_start = Time.get_ticks_msec()
		animated_sprite.stop()
	if running:
		if angular_acceleration < 0.0174533:
			e = angle_difference(v_vec.angle() + f_A*sin((Time.get_ticks_msec() - run_start)/100), facing.angle())
		angular_acceleration = f_stiffness*e - f_damping*angular_velocity
		angular_velocity += angular_acceleration
		
		facing = facing.rotated(-angular_velocity)
		velocity = v_vec * v_tween(ramp_up, Time.get_ticks_msec() - run_start)
	if not running and not velocity == Vector2.ZERO:
		velocity = velocity.normalized() * (speed - v_tween(ramp_down * (velocity.length()/speed), Time.get_ticks_msec() - stop_start))
	
func physics_handle_flashlight():
	$FlashLight.rotation = facing.angle()
	
	# Detection flashlight
	$Cone.rotation = facing.angle()
	for ray in $Cone.get_children():
		if ray.is_colliding():
			checked = 1
		elif checked == 1:
			checked = 0

func v_tween(ramp_time: int, x: float) -> float:
	var m = 1
	if x < ramp_time:
		m = (3*((x/ramp_time)**2) - 2*((x/ramp_time)**3))
	return m * speed

func start(pos: Vector2):
	record = [pos]
	animated_sprite.play("default")
	position = pos
	show()
	for ray in $Cone.get_children():
		ray.add_exception($"../raysbs")

# set the exit point for the player
func set_exit_point(point):
	exit_point = point
	
func on_exit_point_reached():
	if holding_item:
		score_earned.emit(holding_item.point_value)
		holding_item = null

# interact with all the closest artifacts
func interact_with_closest_artifacts():
	var nodes_in_range: Array[Node2D] = interaction_range.get_overlapping_bodies()
	
	var artifacts = []
	
	for body in interaction_range.get_overlapping_bodies():
		var parent = body.get_parent()

		if parent is Artifact:
			artifacts.append(parent)
	
	# sort by proximity!
	artifacts.sort_custom(func(a,b):
		return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position)
	)
	
	# try interacting with all the artifacts in range in order of distance
	for artifact in artifacts:
		if artifact.interact():
			
			holding_item = artifact
			print("now holding artifact")
			break
