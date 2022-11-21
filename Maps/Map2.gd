extends Node2D


onready var player = $Player
onready var camera = $Player/Camera2D

func _ready():
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=2232


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	pass # Replace with function body.


func _on_Down_body_entered(body):
	if "Player" in body.name:
		Global.maps=("res://Maps/Map3.tscn")
		var _k = get_tree().change_scene(Global.maps)
