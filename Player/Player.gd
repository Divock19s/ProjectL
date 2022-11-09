extends KinematicBody2D

var wallSpeed = 150
var walkSpeed = 50
var walkAcc = 500
var motion = Vector2.ZERO
var gravity = 500
var side=1
var dashDirection=1

var kick=false
var dJump=true
var crouched = false
var dash =false
var dashable=true
var slideable=true
var shoot=false
var downKick=false
var bull=false

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
onready var downShape=$Down/CollisionShape2D
onready var kickShape=$Kick/CollisionShape2D
onready var DownKick=$DownKick
onready var Shoot=$Shoot

onready var bullet=preload("res://Player/Bullet.tscn")

func _ready():
	_reset_attack()

func _bullet():
	if !bull and Shoot.frame==1:
		print("yess")
		var b=bullet.instance()
		b.global_position=Shoot.global_position
		b.direction=sign(Shoot.position.x)
		get_parent().add_child(b)
		bull=true

func _reset_attack():
	downShape.set_deferred("disabled",true)
	kickShape.set_deferred("disabled",true)
	DownKick.frame=5
	Shoot.frame=4

func _knock_up(amount):
	_doubleJump(amount)

func _knock(amount,drctn):
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
	if !dash:
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

func _dash(dir):
	motion.x = dir*walkAcc*4
	motion.x=clamp(motion.x,-walkSpeed*6,walkSpeed*6)

func _on_Dashtimer_timeout():
	slideable=true

func _shoot():
	pass

func _on_wSlideTimer_timeout():
	if _rightWall():
		sprite.flip_h = true
		motion.x+= -50
	elif _leftWall():
		sprite.flip_h = false
		motion.x+= 50


func _on_pAnimation_animation_finished(anim_name):
	if anim_name == "AirKick":
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
	_knock(25,-dashDirection)
func _on_Down_body_entered(body):
	_knock_up(150)
