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
var futures = []
var time
var score
var count

const artifacts = [
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
		
	new_round()
	
var past_players = []


func new_round():
	$player.set_physics_process(false)
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
	
func add_artifact(position: Vector2, sprite_name: String):
	var artifact = artifact_scene.instantiate()
	artifact.initialize_data(position, sprite_name)
	add_child(artifact)

func create_player_path():
	var randi1 = randi_range(1, spawns.size())
	var randi2 = randi_range(1, spawns.size())
	
	while randi1 == randi2:
		randi2 = randi_range(1, spawns.size())
		
	$player.start(spawns[randi1 - 1])
	$player.set_exit_point(spawns[randi2 - 1])
	
	var data = {
		"s": randi2 - 1
	}
	
	# spawn portal @ exit point
	portal_sprite.global_position = spawns[randi2 - 1]
	
	print("exit point set to position {s}".format(data))
	
