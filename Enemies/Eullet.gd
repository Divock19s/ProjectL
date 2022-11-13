extends Area2D
onready var ImpactDust=preload("res://Effects/ImpactDust.tscn")
var speed = 100
var direction = 1

func _ready():
	$Timer.start()

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
	if "Player" in body.name:
		body._kill()
	_ImpactDust(global_position,1,1,255,106,106)
	call_deferred("queue_free")


func _on_Timer_timeout():
	_ImpactDust(global_position,1,1,255,106,106)
	call_deferred("queue_free")
