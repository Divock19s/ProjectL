extends StaticBody2D
var open=true
func _ready():
	$Sprite.frame=3
	$CollisionShape2D.set_deferred("disabled",true)
func _hurt(_a,_b,_c,_d,_e):
	pass
func _open():
	if open:
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("Close")
		open=false
