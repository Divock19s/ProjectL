extends Node
onready var Music=$AudioStreamPlayer
var calm=load("res://Assets/Music/GamePlay-Loop-2-Hope.mp3")
var intense=load("res://Assets/Music/Game-play-loop-Intense.mp3")

onready var material1=preload("res://Envirment/Bullet.tres")
onready var material2=preload("res://Envirment/Eullet.tres")
onready var material3=preload("res://Envirment/Explosion.tres")

var music=true
var boss=false
var main = true
var i=0
func _ready():
	_cache(material1)
	_cache(material2)
	_cache(material3)
func _cache(mat):
	var particles_instance = Particles2D.new()
	particles_instance.set_process_material(mat)
	particles_instance.set_one_shot(true)
	particles_instance.set_emitting(true)
	self.add_child(particles_instance)
func _play():
	if music:
		Music.volume_db=-6
		Music.stream=calm
		Music.play()
	else:
		Music.stop()
func _play_boss():
	if music:
		Music.volume_db=0
		Music.stream=intense
		Music.play()
	else:
		Music.stop()
func _on_AudioStreamPlayer_finished():
	if music:
		if boss:
			_play_boss()
		elif !main:
			_play()
	else:
		Music.stop()
