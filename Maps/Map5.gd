extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
onready var dia1=preload("res://Envirment/YellowGem.tscn")

func _ready():
	$"One Dore".open=Global.diamonds>0
	if Global.posa=="left":
		$Timer.start()
		$Player.global_position=$left.global_position
	elif Global.posa=="down":
		$Player.global_position=$down.global_position
	else:
		player.global_position=Global.glo_pos
	$Drone.global_position=$Player.global_position
	camera.global_position=$Player.global_position
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=2148
	camera.limit_bottom=272

func _on_Player_diamonds_updated(diamonds, dir):
	if dir==-1:
		if true:
			var d=dia1.instance()
			d.global_position=Vector2(528,176)
			add_child(d)
		elif true:
			var d=dia1.instance()
			d.global_position=Vector2(528,176)
			add_child(d)

func _teleport():
	Global.posa="check"
	Global.maps="res://Maps/Map1.tscn"
	$AnimationPlayer.play("FADE")
func _on_AnimationPlayer_animation_finished(anim_name):
	var _k = get_tree().change_scene(Global.maps)


func _on_downArea_body_entered(body):
	if "Player" in body.name:
		Global.posa="up"
		Global.maps=("res://Maps/Map4.tscn")
		$AnimationPlayer.play("FADE")

func _on_leftArea_body_entered(body):
	if "Player" in body.name:
		Global.posa="right"
		Global.maps=("res://Maps/Map1.tscn")
		$AnimationPlayer.play("FADE")
