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
	$AnimationPlayer2.play("New Anim")

func _on_AnimationPlayer2_animation_started(anim_name):
	var _k = get_tree().change_scene(Global.maps)

func _on_Timer2_timeout():
	var _k = get_tree().change_scene(Global.maps)
