extends Node2D

var playerPast_scene = preload("res://Players/playerPast.tscn")
var brian_scene = preload("res://gameElements/tempartifact.tscn")

var score
var time

func _ready():
	randomize()
	print("beginning")
	$player.start($playerspawns/playerspawn.position);
	time = 60
	score = 0
	var playerPast = playerPast_scene.instantiate()
	add_child(playerPast)
	playerPast.position = Vector2(500,1000)
	#spawn brians
	var brian1 = brian_scene.instantiate()
	add_child(brian1)
	brian1.position = Vector2(500,1000)
	
	var brian2 = brian_scene.instantiate()
	add_child(brian2)
	brian2.position = Vector2(1900,1750)

	var brian3 = brian_scene.instantiate()
	add_child(brian3)
	brian3.position = Vector2(3500,2050)
	new_round()

func new_round():
	time = 60
	var random_int = randi_range(1, 3)
	if random_int == 1:
		$player.position = $playerspawns/playerspawn.position
	if random_int == 2:
		$player.position = $playerspawns/playerspawn2.position
	if random_int == 3:
		$player.position = $playerspawns/playerspawn3.position
	
	
	
	$RoundTimer.start()
	$HUD.update_timer(time)
	$HUD.update_score(score)

func _on_round_timer_timeout():
	time -= 1
	$RoundTimer.start()
	$HUD.update_timer(time)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		new_round()
