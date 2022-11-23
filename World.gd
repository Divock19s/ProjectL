extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.diamonds=6

func _process(delta):
	if Input.is_action_just_pressed("next"):
		MusicPlayer._play()
	if Input.is_action_just_pressed("ui_down"):
		MusicPlayer.Music.stop()
