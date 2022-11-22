extends Node
onready var Music={"intense":$AudioStreamPlayer,"calm":$AudioStreamPlayer2}
onready var M=1
var music = true
var main = true

func _process(_delta):
	if music and !main:
		if !Music.intense.playing and !Music.calm.playing:
			if M==1:
				Music.intense.play()
				M=2
			else:
				Music.calm.play()
				M=1
	else:
		if Music.intense.playing:
			Music.intense.stop()
		elif Music.calm.playing:
			Music.calm.stop()
		
