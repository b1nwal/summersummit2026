extends CanvasLayer

func update_timer(time):
	$TimeLabel.text = str(time)

func update_score(score):
	$ScoreLabel.text = str(score)
