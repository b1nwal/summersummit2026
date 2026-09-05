extends Camera2D

@onready var target = get_parent() # Drag your player or target here
var lerp_speed: float = 5

func _process(delta: float) -> void:
	if not target:
		return
	var target_pos = target.global_position
	global_position = global_position.lerp(target_pos, lerp_speed * delta)
