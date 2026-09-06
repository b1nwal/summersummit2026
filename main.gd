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
var roundNum
const ROUNDCLOCK = 30
var gameovertime = 0

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
	roundNum = 0
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
	roundNum += 1
	if visited_spawns.size() == spawns.size():
		#_on_game_end()
		return
		
	time = ROUNDCLOCK
	count = 2
	$HUD.update_score(score)
	$HUD.update_timer(time)
	if roundNum == 1:
		$HUD.update_objective(1)
	elif roundNum > 1:
		$HUD.update_objective(2)
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
	
	$HUD.update_ready("Ready?")
	$HUD/CountDownLabel.show()
	$CountDown.start()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		new_round()
		
	if time < 0:
		_game_over()
		time = 9999

func _frame_whole_map() -> void:
	var cam: Camera2D = $player/Camera2D
	cam.set_process(false)

	$player/Sprite2D.hide()
	$player/ItemSprite2D.hide()
	$player/FlashLight.hide()

	var map_size := Vector2(3008, 2816)
	var map_center := Vector2(1504, 1408)
	var vp := get_viewport_rect().size
	var z: float = min(vp.x / map_size.x, vp.y / map_size.y)

	var t := create_tween().set_parallel(true) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(cam, "global_position", map_center, 1.5)
	t.tween_property(cam, "zoom", Vector2(z, z), 1.5)


func _game_over():
	_frame_whole_map()
	$player.set_physics_process(false)
	$RoundTimer.stop()
	$HUD/TimeLabel.hide()
	$HUD/ObjectiveLabel.hide()
	$HUD/CountDownLabel.hide()
	$player.gameoverbruh()
	$HUD.update_ready("You broke the\nSpace Time Continuum")
	$HUD/CountDownLabel.show()
	rewind.emit()
	if $player.record.size() > 1:
		futures.append($player.record)
	if futures:
		for past in futures:
			var past_player_instance = playerPast_scene.instantiate()
			add_child(past_player_instance)
			past_player_instance.position = past[0]
			past_player_instance.set_movement(past.slice(1))
			past_player_instance.gameoverbruh()
			past_player_instance.set_physics_process(false)
			past_players.append(past_player_instance)
			past_player_instance.spotted.connect(_on_spotted)
	$gameovertimer.start()

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
	_game_over()
	
# needs dev
#func _on_game_end():
	#print("game over you got")
	#print(score)
	#print("diamonds")
	
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
	


func _on_gameovertimer_timeout() -> void:
	if gameovertime > ROUNDCLOCK + 5:
		get_tree().change_scene_to_file("res://UI/death_screen.tscn")
	if gameovertime == 3:
		for p in past_players:
			if is_instance_valid(p):
				p.set_physics_process(true)
	if gameovertime < ROUNDCLOCK + 5:
		gameovertime += 1
		$gameovertimer.start()
