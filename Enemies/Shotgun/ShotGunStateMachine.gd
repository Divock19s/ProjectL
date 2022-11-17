extends "res://stateMachine.gd"

func _ready():
	_add_state("Patrol")
	_add_state("Stand")
	_add_state("Detect")
	_add_state("FallDetect")
	_add_state("Shoot")
	_add_state("Close")
	_add_state("Hurt")
	_add_state("Dead")
	_add_state("Fale")
	_add_state("Fall")
	call_deferred("_set_state",states.Patrol)
func _state_logic(delta):
	if parent.hurt:
		if state!=states.Hurt:
			call_deferred("_set_state",states.Hurt)
	if state==states.Patrol :
		if parent.fale:
			call_deferred("_set_state",states.Fale)
		parent._move()
		if parent.turn and (parent._back() or parent._floor() or parent.is_on_wall()):
			if !parent.player.dead:
				parent._turn(-parent.direction)
	elif state==states.Detect:
		if parent.fale:
			call_deferred("_set_state",states.Fale)
		parent._move()
	parent._physics(delta)
func _get_transition(_delta):
	if parent.player.dead:
		if state!=states.Patrol:
			return states.Patrol
	else:
		match state:
			states.Patrol:
				if parent._front():
					if parent._detect()==1:
						return states.Shoot
					elif parent._detect()==2:
						return states.Close
				if !parent.is_on_floor() and parent.motion.y>1:
					return states.Fall
				elif parent.hurt:
					return states.Hurt
				elif parent.fale:
					return states.Fale
			states.Detect:
				if !parent.detect or parent._detect()==3:
					return states.Patrol
				elif parent.attack:
					return states.Shoot
				elif !parent.is_on_floor():
					if parent.motion.y>1:
						return states.FallDetect
				elif parent._detect()==2:
					return states.Close
				elif parent.fale:
					return states.Fale
			states.FallDetect:
				if!parent.detect:
					return states.Fall
				elif parent.is_on_floor():
					if parent.motion.y==1:
						return states.Detect
			states.Fall:
				if parent.is_on_floor():
					return states.Patrol
			states.Close:
				if parent.attack:
					return states.Shoot
				elif parent._detect()!=2:
					return states.Patrol
				elif parent.fale:
					return states.Fale
			states.Fale:
				if !parent.fale:
					return states.Stand
			states.Stand:
				if !parent.stand:
					return states.Patrol
			states.Hurt:
				if !parent.hurt:
					if parent.is_on_floor():
						parent.fale=false
						return states.Patrol
					else:
						return states.Fall
			states.Shoot:
				if !parent.battack:
					if parent._detect()==2:
						return states.Close
					else: return states.Detect
				elif parent.fale:
					parent.BulletTimer.stop()
					return states.Fale
	return null
func _enter_state(new_state,old_state):
	match state:
		states.Close:
			parent.motion.x=0
			parent.ShootTimer.wait_time=1
			parent.animation.play("Close")
		states.Patrol:
			parent.ShootTimer.wait_time=2
			parent.animation.play("Walk")
		states.Detect:
			parent.ShootTimer.wait_time=2
			parent.animation.play("Walk")
			parent.detect=true
			parent.DetectTimer.start()
		states.Fall:
			parent.animation.play("Fall")
		states.FallDetect:
			parent.animation.play("Fall")
			if !(parent.DetectTimer.time_left>0):
				parent.detect=true
				parent.DetectTimer.start()
		states.Shoot:
			parent.battack=true
			parent.animation.play("Attack")
			parent.BulletTimer.start()
			parent.motion.x=0
			parent.attack=false
			parent.ShootTimer.start()
		states.Fale:
			parent.hitShape2.set_deferred("disabled",true)
			parent.motion.x=0
			if parent.failDirection==parent.direction:
				parent.animation.play("FallBack")
			else:
				parent.animation.play("FallFront")
			parent.FailTimer.start()
		states.Stand:
			parent.motion.x=0
			if parent.failDirection==parent.direction:
				parent.animation.play("StandBack")
				parent.stand=true
			else:
				parent.stand=true
				parent.animation.play("StandFront")
		states.Hurt:
			parent.hitShape2.set_deferred("disabled",true)
			parent.animation.play("Hurt")
func _exit_state(old_state,new_state):
	if old_state==states.Fale:
		parent.sprite.position.y=-10
	elif [states.Fale,states.Hurt].has(old_state):
		parent.hitShape2.set_deferred("disabled",false)
		parent.sprite.position.y=-10
	elif old_state==states.Stand:
		parent.hitShape2.set_deferred("disabled",false)
