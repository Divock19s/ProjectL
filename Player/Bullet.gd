extends Area2D
onready var ImpactDust=preload("res://Effects/ImpactDust.tscn")
var speed = 100
var direction = 1
func _ready():
	pass # Replace with function body.

func _process(delta):
	position.x+=direction*speed*delta
	if direction<0:
		$Sprite.flip_h=true
		$Particles2D.position.x=2

func _ImpactDust(position,x,y,color1,color2,color3):
	var i=ImpactDust.instance()
	i.scale.x=x
	i.scale.y=y
	i.modulate = Color8(color1,color2,color3)
	i.pos=position
	get_parent().add_child(i)

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body._hurt("Attack",direction,15,20,25)
	_ImpactDust(global_position,1,1,0,255,237)
	call_deferred("queue_free")
