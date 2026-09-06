extends CanvasLayer

func update_ready(message):
	$CountDownLabel.text = message

func update_timer(time):
	$TimeLabel.text = str(time)

func update_score(score):
	$ScoreLabel.text = str(score)

func update_objective(objective):
	if objective == 1:
		$ObjectiveLabel.text = "Pick up an artifact and escape"
	elif objective == 2:
		$ObjectiveLabel.text = "Pick up an artifact and escape \nAvoid your past selves!"
	else:
		$ObjectiveLabel.text = "the objective label is cooked what did you do"
