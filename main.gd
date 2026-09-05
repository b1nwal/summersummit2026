extends Node2D

var playerPast_scene = preload("res://Players/playerPast.tscn")
var artifact_scene = preload("res://gameElements/tempartifact.tscn")
var time

func _ready():
	randomize()
	$player.start($playerspawns/playerspawn.position);
	print("beginning")
	time = 0
	var playerPast = playerPast_scene.instantiate()
	add_child(playerPast)
	playerPast.position = Vector2(500,1000)
	#spawn brians
	add_artifact(Vector2(500,1000))
	add_artifact(Vector2(1900,1750))
	add_artifact(Vector2(3500,2050))
	new_round()

func new_round():
	var random_int = randi_range(1, 6)
	if random_int == 1:
		$player.position = $playerspawns/playerspawn.position
	if random_int == 2:
		$player.position = $playerspawns/playerspawn2.position
	if random_int == 3:
		$player.position = $playerspawns/playerspawn3.position
	if random_int == 4:
		$player.position = $playerspawns/playerspawn4.position
	if random_int == 5:
		$player.position = $playerspawns/playerspawn5.position
	if random_int == 6:
		$player.position = $playerspawns/playerspawn6.position
	$RoundTimer.start()
	$HUD.update_timer(time)

func add_artifact(position: Vector2):
	var artifact = artifact_scene.instantiate()
	artifact.position = position
	add_child(artifact)
	

func _on_round_timer_timeout():
	time += 1
	$RoundTimer.start()
	$HUD.update_timer(time)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		new_round()
