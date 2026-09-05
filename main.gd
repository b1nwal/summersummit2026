extends Node2D

var playerPast_scene = preload("res://Players/playerPast.tscn")
var artifact_scene = preload("res://gameElements/artifact.tscn")
var futures = []
var time
var score

var artifacts = [
	[Vector2(360, 1997), "stand_empty"], # these are all the ones on the left
	[Vector2(192, 1997), "stand_amongus"], # they all have new names and
	[Vector2(192, 1677), "stand_amongus"], # im too lazy to comeup with it rn
	[Vector2(768, 1037), "stand_amongus"],
	[Vector2(704, 1805), "stand_amongus"], 
	[Vector2(1472, 1101), "stand_amongus"], # new room / N
	[Vector2(1280, 1933), "stand_amongus"], # famous paintings / Central
	[Vector2(1472, 1933), "stand_amongus"], 
	[Vector2(1664, 1933), "stand_amongus"],
	[Vector2(2240, 1613), "stand_amongus"], # war relics / NE
	[Vector2(2624, 1357), "stand_amongus"], 
	[Vector2(2304, 2061), "stand_amongus"], # statues / SE
	[Vector2(2560, 973), "stand_amongus"], # new room / E
	[Vector2(1472, 2445), "stand_amongus"] # great hall / S
]

signal rewind

func _ready():
	randomize()
	print("beginning")
	time = 0
	new_round()

func new_round():
	time = 60
	score = 0
	rewind.emit()
	if $player.record.size() > 1:
		futures.append($player.record)
	if futures:
		for past in futures:
			var past_player_instance = playerPast_scene.instantiate()
			add_child(past_player_instance)
			past_player_instance.position = past[0]
			past_player_instance.set_movement(past.slice(1))
      
	# place artifacts
	for artifact in artifacts:
		add_artifact(artifact[0], artifact[1])	
    
	var random_int = randi_range(1, 6)
	if random_int == 1:
		$player.start($playerspawns/playerspawn.position)
	if random_int == 2:
		$player.start($playerspawns/playerspawn2.position)
	if random_int == 3:
		$player.start($playerspawns/playerspawn3.position)
	if random_int == 4:
		$player.start($playerspawns/playerspawn4.position)
	if random_int == 5:
		$player.start($playerspawns/playerspawn5.position)
	if random_int == 6:
		$player.start($playerspawns/playerspawn6.position)
	$RoundTimer.start()
	$HUD.update_timer(time)
	$HUD.update_score(score)

func add_artifact(position: Vector2, sprite_name: String):
	var artifact = artifact_scene.instantiate()
	artifact.initialize_data(position, sprite_name)
	add_child(artifact)

func _on_round_timer_timeout():
	time -= 1
	$RoundTimer.start()
	$HUD.update_timer(time)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		new_round()
