extends Node

@onready var player = get_parent();

@onready var step_delay = get_meta("delay") 
@onready var step_delay_max = step_delay + 0.05
##delete this for matching speed later??

var running_playing = false
 
func _process(delta):
	play_walk()
	#print(calc_ramp_delay())
	
func calc_ramp_delay():
	var delay_ramp = step_delay_max - step_delay
	var player_real_v = abs(player.velocity.length())
	var player_max_v = player.speed
	return step_delay_max - delay_ramp * player_real_v / player_max_v

func play_walk(): #tempporary
	if (player.running == true && running_playing == false && !player.velocity.is_zero_approx()):
		running_playing = true
		play_dela_wait_async($footsteps, calc_ramp_delay())

func play_delay_async(emitter: FmodEventEmitter2D, delay):
	emitter.play()
	await get_tree().create_timer(delay).timeout
	
func play_dela_wait_async(emitter: FmodEventEmitter2D, delay : float):
	emitter.play()
	await get_tree().create_timer(delay).timeout
	running_playing = false;
	
	
