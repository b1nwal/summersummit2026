extends CharacterBody2D

var run_start
var stop_start
var running = false
var speed = get_meta("speed")
var ramp_time = 300
func start(pos: Vector2):
	position = pos
	show()
	
func v_tween(x: float) -> float:
	var m = 1
	if x < ramp_time:
		m = (3*((x/ramp_time)**2) - 2*((x/ramp_time)**3))
	return m * speed

func _process(delta: float) -> void:
	# movement
	var v_vec = Input.get_vector("move_left","move_right","move_up","move_down")
	
	if not v_vec == Vector2.ZERO and not running:
		running = true
		run_start = Time.get_ticks_msec()
	if v_vec == Vector2.ZERO and running:
		running = false
		stop_start = Time.get_ticks_msec()
		
	if running:
		velocity = v_vec * v_tween(Time.get_ticks_msec() - run_start)
		
	if not running and not velocity == Vector2.ZERO:
		velocity = velocity.normalized() * (speed - v_tween(Time.get_ticks_msec() - stop_start))
		 
	move_and_slide()
