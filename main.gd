extends Node2D

@onready var spawns = [
	$playerspawns/playerspawn.position,
	$playerspawns/playerspawn2.position,
	$playerspawns/playerspawn3.position,
	$playerspawns/playerspawn4.position,
	$playerspawns/playerspawn5.position,
	$playerspawns/playerspawn6.position
]

var playerPast_scene = preload("res://Players/playerPast.tscn")
var artifact_scene = preload("res://gameElements/artifact.tscn")
var portal_texture = preload("res://assets/portals/portal1.png")
var portal_sprite
var visited_spawns = []
var futures = []
var time
var score
var count

const artifacts = [
	[Vector2(192, 1997), "purpleguy"], 
	[Vector2(192, 1677), "purpleguy"], 
	[Vector2(768, 1037), "purpleguy"],
	[Vector2(704, 1805), "purpleguy"], 
	[Vector2(1472, 1101), "purpleguy"], # new room / N
	[Vector2(1280, 1933), "purpleguy"], # famous paintings / Central
	[Vector2(1472, 1933), "purpleguy"], 
	[Vector2(1664, 1933), "purpleguy"],
	[Vector2(2240, 1613), "purpleguy"], # war relics / NE
	[Vector2(2624, 1357), "purpleguy"], 
	[Vector2(2304, 2061), "purpleguy"], # statues / SE
	[Vector2(2560, 973), "purpleguy"], # new room / E
	[Vector2(1472, 2445), "purpleguy"] # great hall / S
]

signal rewind

func _ready():
	randomize()
	print("beginning")
	time = 0
	score = 0
	
	# place artifacts
	for artifact in artifacts:
		add_artifact(artifact[0], artifact[1])
		
	# place portal
	portal_sprite = Sprite2D.new()
	portal_sprite.texture = portal_texture
	add_child(portal_sprite)
	
		
	$player.score_earned.connect(_on_score_added)
	$player.exit_point_reached.connect(_on_exit_reached)
	$player.spotted.connect(_on_spotted)
		
	new_round()
	
var past_players = []


func new_round():
	$player/playerSounds.play_reset_sound()
	$player.set_physics_process(false)
	
	if visited_spawns.size() == spawns.size():
		_on_game_end()
		return
		
	time = 60
	count = 2
	$HUD.update_timer(time)
	$RoundTimer.stop()
	rewind.emit()
	if $player.record.size() > 1:
		futures.append($player.record)
	if futures:
		for past in futures:
			var past_player_instance = playerPast_scene.instantiate()
			add_child(past_player_instance)
			past_player_instance.position = past[0]
			past_player_instance.set_movement(past.slice(1))
			past_player_instance.set_physics_process(false)
			past_players.append(past_player_instance)
			past_player_instance.spotted.connect(_on_spotted)

	
	create_player_path()
	
	$HUD/CountDownLabel.show()
	$CountDown.start()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		new_round()
		
	if time == 0:
		print("Game Over")


func _on_round_timer_timeout():
	time -= 1
	$RoundTimer.start()
	$HUD.update_timer(time)

func _on_count_down_timeout() -> void:
	if count == 0:
		$HUD/CountDownLabel.hide()
		$RoundTimer.start()
		$HUD.update_timer(time)
		$HUD.update_score(score)
		$player.set_physics_process(true)
		for p in past_players:
			if is_instance_valid(p):
				p.set_physics_process(true)
	else:
		count -= 1
		$CountDown.start()
		
func _on_score_added(points):
	score += points
	$HUD.update_score(score)
	
func _on_exit_reached():
	new_round()
	
func _on_spotted():
	print("yo")
# needs dev
func _on_game_end():
	print("game over you got")
	print(score)
	print("diamonds")
	
func add_artifact(position: Vector2, sprite_name: String):
	var artifact = artifact_scene.instantiate()
	artifact.initialize_data(position, sprite_name)
	add_child(artifact)

func create_player_path():
	var randi1 = randi_range(1, spawns.size())
	var randi2 = randi_range(1, spawns.size())
	
	while spawns[randi1 - 1] in visited_spawns:
		randi1 = randi_range(1, spawns.size())
	
	while randi1 == randi2:
		randi2 = randi_range(1, spawns.size())
		
	$player.start(spawns[randi1 - 1])
	$player.set_exit_point(spawns[randi2 - 1])
	
	# spawn portal @ exit point
	portal_sprite.global_position = spawns[randi2 - 1]
	
	visited_spawns.append(spawns[randi1 - 1])
	
	var data = {
		"s": randi2 - 1
	}
	
	print("exit point set to position {s}".format(data))
	
