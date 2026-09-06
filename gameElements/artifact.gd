extends Node2D

const TEXTURE_STAND_EMPTY = preload("res://assets/artifacts/artifact_stand_empty.png")

# null creates an empty stand. otherwise please input a string or else my code explodes
func initialize_data(pos: Vector2, sprite_name = null):
	var sprite = $Sprite2D 
	position = pos
	
	if sprite_name == null:
		sprite.texture = TEXTURE_STAND_EMPTY
	
	else:
		var data = {
			"sprite_name": sprite_name
		}
		sprite.texture = load("res://assets/artifacts/artifact_{sprite_name}.png".format(data))
	
