extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
var innn=false
func _ready():
	if !Global.fog:
		!$CanvasLayer2.call_deferred("queue_free")
	MusicPlayer.boss=true
	MusicPlayer._play_boss()
	$Player/CanvasLayer/HealthBar.visible=false
	$Drone.global_position=$Player.global_position
	camera.global_position=$Player.global_position
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=832
	camera.limit_bottom=320
	camera.zoom.x=0.2
	camera.zoom.y=0.2
	Global._save()

func _end():
	Global.posa="check"
	Global.maps=("res://Maps/Map1.tscn")
	$AnimationPlayer.play("end")

func _on_Out_body_entered(body):
	if"Player"in body.name:
		Global.posa="up"
		Global.maps=("res://Maps/Map6.tscn")
		$AnimationPlayer.play("FADE")


func _on_In_body_entered(body):
	if"Player"in body.name:
		if !innn:
			$Player/CanvasLayer/HealthBar.visible=true
			$Tween.interpolate_property(camera,"zoom",camera.zoom,Vector2(0.25,0.25),2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1.0)
			$Tween.start()
			$Tween.interpolate_property(camera,"limit_right",camera.limit_right,384,7,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1.0)
			$Tween.start()
			$Door._open()
			innn=true
			$Boss._star()
			$Door/CollisionShape2D.set_deferred("disabled",false)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="end":
		var _k = get_tree().change_scene("res://Maps/end.tscn")
	else:
		MusicPlayer.boss=false
		MusicPlayer._play()
		player._store_health()
		var _k = get_tree().change_scene(Global.maps)
