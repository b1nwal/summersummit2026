extends CanvasLayer

@onready var waypoint := $Waypoint
@onready var waypointBL := $Waypoint/bottomleft
@onready var waypointBR := $Waypoint/bottomright
@onready var waypointB := $Waypoint/bottom
@onready var waypointL := $Waypoint/left
@onready var waypointR := $Waypoint/right
@onready var waypointTL := $Waypoint/topleft
@onready var waypointTR := $Waypoint/topright
@onready var waypointT := $Waypoint/top

const top = 96.0
const left = 96.0
const right = 1825.0
const bottom = 984.0
const WAYPOINT_MARGIN := 96.0
var waypoint_target = null

func _process(delta: float) -> void:
	if waypoint_target == null:
		waypoint.hide()
		return
	
	var screen_pos: Vector2 = get_viewport().get_canvas_transform() * waypoint_target
	var safe := get_viewport().get_visible_rect().grow(-WAYPOINT_MARGIN)
	var center = safe.get_center()
	 
	if safe.has_point(screen_pos):
		waypoint.hide()
		return
	
	waypoint.show()
	waypoint.position = screen_pos.clamp(safe.position, safe.end)
	
	for s in waypoint.get_children():
		s.hide()
	if waypoint.position.x < left + WAYPOINT_MARGIN and waypoint.position.y < top + WAYPOINT_MARGIN:
		waypointTL.show()
	elif waypoint.position.x > right - WAYPOINT_MARGIN and waypoint.position.y < top + WAYPOINT_MARGIN:
		waypointTR.show()
	elif waypoint.position.x > right - WAYPOINT_MARGIN and waypoint.position.y > bottom - WAYPOINT_MARGIN:
		waypointBR.show()
	elif waypoint.position.x < left + WAYPOINT_MARGIN and waypoint.position.y > bottom - WAYPOINT_MARGIN:
		waypointBL.show()
	elif waypoint.position.x == left:
		waypointL.show()
	elif waypoint.position.x == right:
		waypointR.show()
	elif waypoint.position.y == top:
		waypointT.show()
	elif waypoint.position.y == bottom:
		waypointB.show()
		
	print(waypoint.position)

func update_ready(message):
	$CountDownLabel.text = message
	if message.contains("Space"):
		$CountDownLabel.add_theme_color_override("font_color", Color(0, 0, 0))
		$CountDownLabel.add_theme_color_override("font_outline_color", Color(255, 255, 255))
	else:
		$CountDownLabel.add_theme_color_override("font_color", Color(255, 255, 255))
		$CountDownLabel.add_theme_color_override("font_outline_color", Color(0, 0, 0))

func update_timer(time):
	$TimeLabel.text = str(time)
	if time <= 10:
		$TimeLabel.add_theme_color_override("font_color", Color(255, 0, 0))
		$TimeLabel.add_theme_color_override("font_outline_color", Color(255, 255, 255))
	else:
		$TimeLabel.add_theme_color_override("font_color", Color(255, 255, 255))
		$TimeLabel.add_theme_color_override("font_outline_color", Color(0, 0, 0))

func update_score(score):
	$ScoreLabel.text = str(score)

func update_objective(objective):
	if objective == 1:
		$ObjectiveLabel2.hide()
		$ObjectiveLabel.text = "Steal an artifact and escape."
	elif objective == 2:
		$ObjectiveLabel.text = "Steal an artifact and escape."
		$ObjectiveLabel2.show()
		$ObjectiveLabel2.text = "Avoid your past selves."
	else:
		$ObjectiveLabel.text = "the objective label is cooked what did you do"

func set_waypoint(pos) -> void:
	waypoint_target = pos
