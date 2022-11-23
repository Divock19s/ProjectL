extends Node
onready var Music=$AudioStreamPlayer
var calm=load("res://Assets/Music/GamePlay-Loop-2-Hope.mp3")
var intense=load("res://Assets/Music/Game-play-loop-Intense.mp3")
var M=1
var music = true
var main = true
var i=0
func _play():
	if !music:
		Music.stop()
		return
	if i>1:
		if M==1:
			Music.volume_db=24
			Music.stream=intense
			M=2
		elif M==2:
			Music.volume_db=0
			Music.stream=calm
			M=1
		i=0
	Music.play()

func _on_AudioStreamPlayer_finished():
	if !main:
		i+=1
		_play()
