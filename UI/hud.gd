extends CanvasLayer

func update_timer(time):
	$TimeLabel.text = str(time)
	if time <= 15:
		$TimeLabel.add_theme_color_override("font_color", Color(255, 0, 0))
		$TimeLabel.add_theme_color_override("font_outline_color", Color(255, 255, 255))
	elif time > 15:
		$TimeLabel.add_theme_color_override("font_color", Color(255, 255, 255))
		$TimeLabel.add_theme_color_override("font_outline_color", Color(0, 0, 0))

func update_score(score):
	$MarginContainer/ScoreLabel.text = str(score)
