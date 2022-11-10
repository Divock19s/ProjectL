extends KinematicBody2D

var detect=false
var attack
var hurt=false
var fale=false
var turn=true

var speed = 20
var gravity = 500
var direction = 1
var failDirection =1
var motion=Vector2.ZERO

onready var flor=$Floor
onready var front=$Front
onready var back=$Back
onready var hitBox=$Area2D
onready var hitShape=$Area2D/CollisionShape2D
onready var animation=$AnimationPlayer
onready var DetectTimer=$DetectTimer
onready var wallTimer=$WallTimer

func _ready():
	hitShape.disabled=true

func _fale(dir):
	failDirection=dir
	fale=true

func _move():
	motion.x+=speed*direction
	motion.x=clamp(motion.x,-speed,speed)
func _physics():
	if !is_on_floor():
		motion.y+=gravity
		motion.y=clamp(motion.y,-gravity,gravity)
	else:
		motion.y=0
	motion=move_and_slide(motion,Vector2.UP)

func _floor():
	return !flor.is_colliding()

func _back():
	var _name=back.get_collider()
	if _name!=null:
		if _name.name=="Player" :
			return true

func _front():
	return front.is_colliding()

func _detect():
	var _name=front.get_collider()
	if _name!=null:
		if _name.name=="Player" :
			if get_global_transform().origin.distance_to(front.get_collision_point()) <=12:
				return 2
			return 1

func _turn(dir):
	if turn:
		$Sprite.flip_h=dir==-1
		direction=dir
		flor.position.x=4*dir
		front.scale.x=dir
		back.scale.x=dir
		hitBox.scale.x=dir
		turn=false
		wallTimer.start()


func _on_DetectTimer_timeout():
	detect=false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="Attack":
		attack=false


func _on_WallTimer_timeout():
	turn=true
