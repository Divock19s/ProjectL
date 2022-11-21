extends Node
onready var Music=$AudioStreamPlayer
var music = false
func _process(_delta):
	if !Music.playing and music:
		Music.play()
	elif !music:
		Music.stop()
		
