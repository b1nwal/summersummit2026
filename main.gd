extends Node2D

var playerPast_scene = preload("res://Players/playerPast.tscn")
var brian_scene = preload("res://gameElements/tempartifact.tscn")
var futures = []
var time

signal rewind

func _ready():
	randomize()
	$player.start($playerspawns/playerspawn.position);
	print("beginning")
	time = 0
	new_round()

func new_round():
	rewind.emit()
	if $player.record.size() > 1:
		futures.append($player.record)
	if futures:
		for past in futures:
			var past_player_instance = playerPast_scene.instantiate()
			add_child(past_player_instance)
			past_player_instance.position = past[0]
			past_player_instance.set_movement(past.slice(1))
	var random_int = randi_range(1, 3)
	if random_int == 1:
		$player.start($playerspawns/playerspawn.position)
	if random_int == 2:
		$player.start($playerspawns/playerspawn2.position)
	if random_int == 3:
		$player.start($playerspawns/playerspawn3.position)
	$RoundTimer.start()
	$HUD.update_timer(time)

func _on_round_timer_timeout():
	time += 1
	$RoundTimer.start()
	$HUD.update_timer(time)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		new_round()
