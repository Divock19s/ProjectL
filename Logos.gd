extends Node2D
func _ready():
	OS.window_fullscreen=Global.FullScreen
	$AnimationPlayer.play("Start")
	$Timer.start()
func _on_AnimationPlayer_animation_finished(_anim_name):
	var _k = get_tree().change_scene("res://World.tscn")
func _on_Timer_timeout():
	var _k = get_tree().change_scene("res://World.tscn")
