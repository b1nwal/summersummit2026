extends Node2D

var time

func _ready():
	time = 0
	new_round()

func new_round():
	$RoundTimer.start()
	$HUD.update_timer(time)

func _on_round_timer_timeout():
	time += 1
	$RoundTimer.start()
	$HUD.update_timer(time)
