extends Area2D
onready var explo=preload("res://Envirment/Explosion.tscn")
func _ready():
	if Global.diamonds>=5:
		$AnimatedSprite.play("Idle")
		call_deferred("queue_free")
func _on_Area2D_body_entered(body):
	if "Player" in body.name and Global.diamonds == 4:
		Global.posa="check"
		Global.glo_pos=body.global_position
		var r = explo.instance()
		r.global_position=global_position
		r.modulate=Color8(247,223,79)
		get_parent().add_child(r)
		Global.diamonds=5
		body.diamonds=5
		$AnimatedSprite.play("Collect")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.frame==8:
		call_deferred("queue_free")
