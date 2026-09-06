extends CanvasLayer

func update_ready(message):
	$CountDownLabel.text = message

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
