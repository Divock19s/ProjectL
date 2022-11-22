extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.diamonds=6


func _on_Area2D_body_entered(body):
	if "TileMap" in body.name:
		print("ez pz")
