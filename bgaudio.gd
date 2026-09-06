extends Node

func restart():
	stop();
	$music.set_parameter("on", 0)
	$music.play()
	
func stop():
	$music.stop();
	
func release_intro():
	$music.set_parameter("on", 1)
	
