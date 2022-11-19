extends Node2D
func _ready():
	OS.window_fullscreen=Global.FullScreen
	$AnimationPlayer.play("Start")

func _input(event):
	if event.is_action_pressed("esc"):
		$Timer2.start()
	if event.is_action_released("esc"):
		$Timer2.stop()

func _on_AnimationPlayer_animation_finished(_anim_name):
	var _k = get_tree().change_scene("res://Menu/MainManu.tscn")
