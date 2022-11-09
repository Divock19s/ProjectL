extends Area2D

var speed = 100
var direction = 1
func _ready():
	pass # Replace with function body.

func _process(delta):
	position.x+=direction*speed*delta
	if direction<0:
		$Sprite.flip_h=true
		$Particles2D.position.x=2

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body._hurt(10)
	call_deferred("queue_free")
