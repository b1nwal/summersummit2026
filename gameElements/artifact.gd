class_name Artifact
extends Node2D

# artifact's sprite child node

const TEXTURE_STAND_EMPTY = preload("res://assets/artifacts/artifact_stand_empty.png")
var collected # boolean: is the artifact collected?
var treasure_sprite_name
var point_value = 200

# null creates an empty stand. otherwise please input a string or else my code explodes
func initialize_data(pos: Vector2, sprite_name = null):
	
	var sprite = $Sprite2D
	
	collected = false
	position = pos
	
	if sprite_name == null:
		sprite.texture = TEXTURE_STAND_EMPTY
		collected = true
	
	else:
		treasure_sprite_name = sprite_name
		
		var data = {
			"sprite_name": sprite_name
		}
		
		sprite.texture = load("res://assets/artifacts/artifact_stand_{sprite_name}.png".format(data))
	
	
# returns true if the artifact was successfully collected. returns false if you cant interact.
func interact() -> bool:
	
	var sprite = $Sprite2D
	
	if collected:
		return false
		
	else:
		collected = true
		sprite.texture = TEXTURE_STAND_EMPTY
		return true 
		
# returns the name of the artifact to render on player 
func get_sprite_name() -> String:
	return treasure_sprite_name
