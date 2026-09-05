extends CharacterBody2D

@onready var speed = get_meta("speed")
@onready var animated_sprite = $Sprite2D

var run_start
var stop_start
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
var record = []
var record_index = 1

func _ready() -> void:
	get_tree().current_scene.connect("rewind",_on_rewind)

func set_movement(_record: Array) -> void:
	record = _record

func _on_rewind() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	# movement
	var v_vec = record[record_index]
	record_index += 1
	if record_index > record.size() - 1:
		queue_free()
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
	
	$FlashLight.rotation = facing.angle() - PI/2
	
	# Detection flashlight
	$Cone.rotation = facing.angle() - PI/2
	for ray in $Cone.get_children():
		if ray.is_colliding():
			checked = 1
		elif checked == 1:
			checked = 0

	move_and_slide()
	
func v_tween(ramp_time: int, x: float) -> float:
	var m = 1
	if x < ramp_time:
		m = (3*((x/ramp_time)**2) - 2*((x/ramp_time)**3))
	return m * speed

func _on_emit() -> void:
	queue_free()

func start(pos: Vector2):
	print("i am a past player being started")
	animated_sprite.play("default")
	position = pos
	show()
	for ray in $Cone.get_children():
		ray.add_exception($"../MapCollisionPlaceholder")
