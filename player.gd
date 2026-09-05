extends CharacterBody2D

@onready var speed = get_meta("speed")

var facing := Vector2.RIGHT

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left","move_right","move_up","move_down")
	if input_dir != Vector2.ZERO:
		facing = input_dir
	velocity = input_dir * speed
	move_and_slide()

	$FlashLight.rotation = facing.angle() + (PI/4)

func start(pos: Vector2):
	position = pos
	show()
