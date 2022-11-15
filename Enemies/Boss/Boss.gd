extends KinematicBody2D

var shoot=false
var attack=false
var battack=true
var hurt=false
var turn=true
var dead=false
var charge=false
var jumpp=false
var jamp=false
var tim=true
var transit=true

var jumpCount=0
var health=200
var speed = 50
var gravity = 500
var jump = -400
var direction = 1
var motion=Vector2.ZERO
var target = 0
var jumpcount=0
var targetx
var targety
var rect
var distance

onready var player=get_parent().get_node("Player")
onready var bullet=preload("res://Enemies/Eullet.tscn")
onready var SlideDust=preload("res://Effects/SlideDust.tscn")
onready var LandDust=preload("res://Effects/LandDust.tscn")
onready var Spos=$ShootPosition
onready var Spos2=$ShootPosition2
onready var Spos3=$ShootPosition3
onready var animation=$AnimationPlayer
onready var DetectTimer=$DetectTimer
onready var BulletTimer=$BulletTimer
onready var IdleTimer=$IdleTimer
onready var ChargeTimer=$ChargeTimer
onready var ShootTimer=$ShootTimer
onready var wallTimer=$WallTimer
onready var sprite=$Sprite
onready var hitShape2=$Collide/CollisionShape2D
onready var attackArea=$Area2D/CollisionShape2D
onready var attackArea2d=$Area2D

func _shoot(os):
	var b=bullet.instance()
	b.global_position=os.global_position
	b.direction=sign(os.position.x)
	get_parent().add_child(b)

func _hurt(type,direct,damage,x,y):
	if type!="fail":
		hurt=true
		health-=damage
		health=clamp(health,0,1000)
		motion.x=0
		$HurtAnimation.play("Hurt")

func _move():
	motion.x+=speed*-sign(_detect())
	motion.x=clamp(motion.x,-speed,speed)

func _physics(delta):
	motion.y+=gravity*delta
	if motion.y>gravity:
		motion.y=gravity
	motion=move_and_slide(motion,Vector2.UP)

func _detectx():
	if player != null:
		return abs(global_position.x-player.global_position.x)

func _detecty():
	if player != null:
		return abs(global_position.y-player.global_position.y)

func _detect():
	if player != null:
		return global_position.x-player.global_position.x

func _close():
	return _detectx()<=30 and _detecty() < 13

func _jump(delta):
	if abs(targetx-global_position.x) < 10 and abs(targetx-global_position.x) >0 :
		motion.x=lerp(motion.x,0,0.1)
		if is_on_floor():
			animation.play("JumpFall")
	elif abs(targetx-global_position.x)<=abs(distance/2):
		motion.x+=speed*rect
	else:
		motion.x+=speed*rect*delta
		motion.y+=jump*delta*3
	if abs(targety-global_position.y)>200:
		motion.y=0
	motion.x=clamp(motion.x,-50,50)
	if motion.y<-700:
		motion.y=-700

func _target():
	distance=_detectx()
	targetx = player.global_position.x
	targety= player.global_position.y
	rect = -sign(_detect())
	animation.play("JumpMid")

func _turn(dir):
	$Sprite.flip_h=dir==-1
	direction=dir
	Spos.position.x=-dir*11
	Spos2.position.x=-dir*11
	Spos3.position.x=-dir*11
	attackArea2d.scale.x=dir
	turn=false

func _on_DetectTimer_timeout():
	battack=true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="Attack":
		attack=false
	elif anim_name=="Hurt":
		hurt=false
	elif anim_name=="Jump":
		_target()
	elif anim_name=="JumpFall":
		jumpp=false
	elif anim_name=="transit":
		transit=false
	elif anim_name=="Shoot":
		shoot=false

func _on_WallTimer_timeout():
	charge=false

func _on_ShootTimer_timeout():
	shoot=true

func _on_BulletTimer_timeout():
	_shoot(Spos)
	_shoot(Spos2)
	_shoot(Spos3)


func _on_Collide_body_entered(body):
	if "Player" in body.name:
		body._kill()


func _on_Area2D_body_entered(body):
	pass


func _on_ChargeTimer_timeout():
	charge=true


func _on_IdleTimer_timeout():
	tim=false


func _on_FallArea_body_entered(body):
	if "Player" in body.name:
		if !body.dash:
			body._kill()
