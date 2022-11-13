extends Node2D

onready var collision=$Detect/CollisionShape2D
func _ready():
	$Container.position.y=-13.5
	$Container/Sprite.frame=1
func _on_Detect_body_entered(body):
	if "Player" in body.name:
		$AnimationPlayer.play("Smash")
		$Container/Sprite.frame=0
		collision.set_deferred("disabled",true)
func _on_Hit_body_entered(body):
	if "Player" in body.name:
		body._kill()


func _on_AnimationPlayer_animation_finished(anim_name):
	if "Smash" in anim_name:
		$AnimationPlayer.play("Restore")
		$Container/Sprite.frame=1
	elif "Restore" in anim_name:
		collision.set_deferred("disabled",false)
