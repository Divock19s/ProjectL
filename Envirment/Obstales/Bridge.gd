extends StaticBody2D
func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		$AnimationPlayer.play("Fall")
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
