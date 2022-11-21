extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D

func _ready():
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=1664

func _on_Text1_text_done():
#	Global.progress=1
	$Door._open()


func _on_AnimationPlayer_animation_finished(anim_name):
	Global.maps="res://Maps/Map2.tscn"
	var _k = get_tree().change_scene(Global.maps)


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		$AnimationPlayer.play("FADE")
