extends CharacterBody2D

var speed = get_meta("speed")

func start(pos: Vector2):
	position = pos
	show()
	
func _process(delta: float) -> void:
	# movement
	velocity = Input.get_vector("move_left","move_right","move_up","move_down") * speed
	move_and_slide()
