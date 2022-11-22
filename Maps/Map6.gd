extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D

func _ready():
	if Global.posa=="up":
		$Player.global_position=$Up.global_position
	elif Global.posa=="down":
		$Player.global_position=$Up2.global_position
	else:
		player.global_position=Global.glo_pos
	$Drone.global_position=$Player.global_position
	camera.global_position=$Player.global_position
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=992
	camera.limit_bottom=2768

func _on_Area2D2_body_entered(body):
	if"Player"in body.name:
		Global.posa="up"
		Global.maps=("res://Maps/Map5.tscn")
		$AnimationPlayer.play("FADE")

func _teleport():
	Global.posa="check"
	Global.maps="res://Maps/Map1.tscn"
	$AnimationPlayer.play("FADE")
func _on_Area2D_body_entered(body):
	if"Player"in body.name:
		Global.posa="up"
		Global.maps=("res://Maps/Map7.tscn")
		$AnimationPlayer.play("FADE")



func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.
