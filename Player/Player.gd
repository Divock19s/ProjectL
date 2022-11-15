extends KinematicBody2D

signal health_updated(health)
signal diamonds_updated(diamonds,dir)

var wallSpeed = 150
var walkSpeed = 50
var walkAcc = 500
var motion = Vector2.ZERO
var gravity = 500
var side=1
var dashDirection=1
var diamonds =0 setget _set_diamonds
var health =4 setget _set_health
var dowcount = 1

var die=false
var kick=false
var dJump=true
var crouched = false
var dash =false
var dead = true
var dashable=true
var slideable=true
var shoot=false
var downKick=false
var bull=false
var sliding=false
var spawned = false
var hurtable = true

var canSlide=true
var canDoubleJump=true
var canDash=true
var canWallJump=true
var canShoot=true
var canDownKick=true

onready var sprite=$Sprite
onready var plAnimation=$pAnimation
onready var label=$Label
onready var dashTimer=$Dashtimer
onready var wallSlideTimer=$wSlideTimer 
onready var runDustTimer=$RunDustTimer
onready var wallDustTimer=$WallDustTimer
onready var slideDustTimer=$SlideDustTimer
onready var dashEffectTimer=$DashEffectTimer
onready var downShape=$Down/CollisionShape2D
onready var kickShape=$Kick/CollisionShape2D
onready var DownKick=$DownKick
onready var Shoot=$Shoot
onready var camera=$Camera2D
onready var shake=$Camera2D/Tween
onready var squash=$Squash

onready var bullet=preload("res://Player/Bullet.tscn")
onready var RunDust=preload("res://Effects/WalkDust.tscn")
onready var ImpactDust=preload("res://Effects/ImpactDust.tscn")
onready var ImpactDust2=preload("res://Effects/ImpactDust2.tscn")
onready var ImpactDust3=preload("res://Effects/ImpactDust3.tscn")
onready var WallDust=preload("res://Effects/WallDust.tscn")
onready var LandDust=preload("res://Effects/LandDust.tscn")
onready var JumpDust=preload("res://Effects/JumpDust.tscn")
onready var SlideDust=preload("res://Effects/SlideDust.tscn")
onready var DashEffect=preload("res://Effects/DashEffect.tscn")

func _ready():
	_reset_attack()

func _kill():
	if !downKick:
		if hurtable:
			_set_health(health-1)

func _shake(duration=0.2,frequency=15,amplitude=16,priority=0):
	shake._start(duration,frequency,amplitude,priority)

func _bullet():
	if !bull and Shoot.frame==1:
		var b=bullet.instance()
		b.global_position=Shoot.global_position
		b.direction=sign(Shoot.position.x)
		get_parent().add_child(b)
		bull=true

func _ImpactDust(position,x,y,color1,color2,color3,second):
	var i=ImpactDust.instance()
	i.scale.x=x
	i.scale.y=y
	i.modulate = Color8(color1,color2,color3)
	i.pos=position
	get_parent().add_child(i)
	if second:
		var i2=ImpactDust3.instance()
		i2.scale.x=x*0.5
		i2.scale.y=x*0.5
		i2.modulate = Color8(color1,color2,color3)
		i2.pos=position
		get_parent().add_child(i2)

func _RunDust():
	var d=RunDust.instance()
	d.pos=global_position
	d.flipp=sign(Shoot.position.x)
	get_parent().add_child(d)
	
func _WallDust():
	var w=WallDust.instance()
	w.pos=global_position
	w.flipp=sign(Shoot.position.x)
	get_parent().add_child(w)

func _JumpDust():
	var j=JumpDust.instance()
	j.pos=global_position
	get_parent().add_child(j)

func _LandDust():
	var l=LandDust.instance()
	l.pos=global_position
	get_parent().add_child(l)

func _SlideDust():
	var s=SlideDust.instance()
	s.pos=global_position
	s.flipp=sign(Shoot.position.x)
	get_parent().add_child(s)

func _DashEffect():
	var d=DashEffect.instance()
	d.pos=global_position
	d.flipp=sign(Shoot.position.x)
	get_parent().add_child(d)

func _reset_attack():
	downShape.set_deferred("disabled",true)
	kickShape.set_deferred("disabled",true)
	DownKick.frame=9
	Shoot.frame=4

func _knock_up(amount):
	_shake(0.2,7,2,0)
	_doubleJump(amount)

func _knock(amount,drctn):
	_shake(0.2,7,2,0)
	motion.x=0
	motion.x+=amount*drctn

func _direction(direction):
	if direction!=0:
		if direction<0:
			sprite.flip_h=true
			Shoot.flip_h=true
			DownKick.flip_h=true
			Shoot.position.x=-9
			kickShape.position.x=-9
		else:
			sprite.flip_h=false
			Shoot.flip_h=false
			DownKick.flip_h=false
			Shoot.position.x=9
			kickShape.position.x=9
		dashDirection=direction
	_camera(direction)

func _camera(dir):
	camera.position.x=lerp(camera.position.x,50*dir,0.05)

func _cameray():
	if motion.y>250:
		camera.position.y=lerp(camera.position.y,20,0.1)
	else:
		camera.position.y=lerp(camera.position.y,-20,0.05)

func _walk(dir):
	if dir !=0:
		motion.x += dir*walkAcc
		motion.x=clamp(motion.x,-walkSpeed,walkSpeed)
	else:
		motion.x = int(lerp(motion.x,0,0.35))

func _air(dir):
	if !is_on_floor():
		if dir !=0:
			motion.x += dir*walkAcc/4
			motion.x=clamp(motion.x,-walkSpeed,walkSpeed)
		else:
			motion.x = lerp(motion.x,0,0.05)

func _wallSlide():
	motion.y=0
	gravity = 50
	if _rightWall():
		dashDirection=-1
		sprite.flip_h = true
		Shoot.flip_h=true
		DownKick.flip_h=true
		Shoot.position.x=-9
		kickShape.position.x=-9
		side=-1
		return -1
	elif _leftWall():
		dashDirection=1
		sprite.flip_h = false
		Shoot.flip_h=false
		DownKick.flip_h=false
		Shoot.position.x=9
		kickShape.position.x=9
		side=1
		return 1

func _wallJump(jum):
	motion.y=0
	_jump(jum)
	if _rightWall():
		sprite.flip_h = true
		motion.x+= -wallSpeed
	elif _leftWall():
		sprite.flip_h = false
		motion.x+= wallSpeed

func _slide():
	$CrouchCollision.set_deferred("disabled",true)

func _crouch():
	$CrouchCollision.set_deferred("disabled",true)
	walkSpeed=20
	walkAcc=100
	crouched = true

func _uncrouch():
	$CrouchCollision.set_deferred("disabled",false)
	walkSpeed = 50
	walkAcc = 500
	crouched = false

func _jump(jum):
	motion.y+=-jum

func _doubleJump(jum):
	motion.y=0
	motion.y+=-jum

func _physics(grav,del):
	_cameray()
	if !dash or sliding:
		motion.y+=gravity*del
		motion.y=clamp(motion.y,-gravity,gravity)
	else:
		motion.y=0
	motion=move_and_slide(motion,Vector2.UP)

func _roof():
	return $Up1.is_colliding() or $Up2.is_colliding()

func _leftWall():
	return $Left.is_colliding() or $Left2.is_colliding()

func _rightWall():
	return $Right.is_colliding() or $Right2.is_colliding()

func _dash(dir,slide):
	sliding=slide
	motion.x = dir*walkAcc*4
	motion.x=clamp(motion.x,-walkSpeed*6,walkSpeed*6)

func _on_Dashtimer_timeout():
	slideable=true

func _on_wSlideTimer_timeout():
	if _rightWall():
		sprite.flip_h = true
		motion.x+= -50
	elif _leftWall():
		sprite.flip_h = false
		motion.x+= 50


func _on_pAnimation_animation_finished(anim_name):
	if anim_name == "AirKick":
		kick=false
		dash=false
	elif anim_name == "Slide":
		dash=false
	elif anim_name == "Kick":
		kick=false
	elif anim_name == "DownKick":
		downKick=false
	elif anim_name == "Shoot":
		shoot=false

func _on_Kick_body_entered(body):
	_ImpactDust(kickShape.global_position,1,1,255,255,255,false)
	if body.is_in_group("enemies"):
		if !slideable:
			body._hurt("fail",dashDirection,0,0,0)
		elif dash:
			_knock(25,-dashDirection)
			body._hurt("Attack",dashDirection,50,50,70)
		elif kick:
			_knock(25,-dashDirection)
			body._hurt("Attack",dashDirection,15,40,50)
		elif shoot:
			_knock(25,-dashDirection)
			body._hurt("Attack",dashDirection,20,40,50)

func _on_Down_body_entered(body):
	motion.y=0
	_knock_up(200)
	if !spawned:
		if body.is_in_group("enemies"):
			body._hurt("Attack",dashDirection,50,0,0)
		_ImpactDust(downShape.global_position,1.5,1.5,203,219,252,true)
		spawned = true


func _on_RunDustTimer_timeout():
	_RunDust()
	runDustTimer.start()


func _on_SlideDustTimer_timeout():
	_SlideDust()
	slideDustTimer.start()


func _on_DashEffectTimer_timeout():
	_DashEffect()
	dashEffectTimer.start()


func _on_WallDustTimer2_timeout():
	_WallDust()
	wallDustTimer.start()

func _die():
	pass

func _set_diamonds(d):
	var prevd=diamonds
	diamonds= clamp(d,0,6)
	if diamonds!=prevd:
		if diamonds-prevd<0:
			emit_signal("diamonds_updated",diamonds,-1)
		elif diamonds-prevd>0:
			emit_signal("diamonds_updated",diamonds,1)

func _set_health(h):
	var prevh=health
	health= clamp(h,0,4)
	if health!=prevh:
		emit_signal("health_updated",health)
		if health==0:
			_die()
		else:
			hurtable=false
			$HurtAnimation.play("Hurt")


func _on_HurtAnimation_animation_finished(anim_name):
	hurtable=true

func _input(event):
	if event.is_action_released("ui_focus_next"):
		_set_diamonds(diamonds+1)
	elif event.is_action_released("ui_focus_prev"):
		_set_diamonds(diamonds-1)
