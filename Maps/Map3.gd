extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.diamonds=1


func _on_Area2D2_body_entered(body):
	if "Player" in body.name:
		body._kill(0,4,0)
