extends Node2D

func _ready():
	$player.start($playerspawn.position);
	print("beginning")
