extends Node2D
var time

func _ready():
	$player.start($playerspawn.position);
	print("beginning")
	time = 0
	new_round()

func new_round():
	$RoundTimer.start()
	$HUD.update_timer(time)

func _on_round_timer_timeout():
	time += 1
	$RoundTimer.start()
	$HUD.update_timer(time)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
