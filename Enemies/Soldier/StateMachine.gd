extends "res://stateMachine.gd"

func _ready():
	_add_state("Patrol")
	_add_state("Stand")
	_add_state("Detect")
	_add_state("FallDetect")
	_add_state("Attack")
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
			parent._turn(-parent.direction)
	elif state==states.Detect:
		if parent.fale:
			call_deferred("_set_state",states.Fale)
		parent._move()
		if parent.turn and (parent._back() or parent._floor() or parent.is_on_wall()):
			parent._turn(-parent.direction)
	parent._physics()
func _get_transition(_delta):
	match state:
		states.Patrol:
			if parent._front():
				if parent._detect()==1:
					return states.Detect
				elif parent._detect()==2:
					return states.Attack
			elif !parent.is_on_floor():
				return states.Fall
			elif parent.hurt:
				return states.Hurt
			elif parent.fale:
				return states.Fale
		states.Detect:
			if!parent.detect:
				return states.Patrol
			elif !parent.is_on_floor():
				if parent.motion.y>1:
					return states.FallDetect
			elif parent._detect()==2:
				return states.Attack
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
		states.Attack:
			if !parent.attack:
				return states.Patrol
			elif parent.fale:
				return states.Fale
		states.Fale:
			return states.Stand
		states.Hurt:
			if !parent.hurt:
				if parent.is_on_floor():
					return states.Patrol
				else:
					return states.Fall
	return null
func _enter_state(new_state,old_state):
	parent.hitShape.disabled=true
	match state:
		states.Patrol:
			parent.speed = 20
			parent.animation.play("Walk")
		states.Detect:
			parent.speed = 40
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
		states.Attack:
			parent.motion.x=0
			parent.attack=true
			parent.animation.play("Attack")
		states.Fale:
			if parent.failDirection==parent.direction:
				parent.animation.play("FallBack")
			else:
				parent.animation.play("FallFront")
			parent.FailTimer.start()
		states.Stand:
			if parent.failDirection==parent.direction:
				parent.animation.play("StandBack")
			else:
				parent.animation.play("StandFront")
		states.Hurt:
			parent.animation.play("Hurt")
func _exit_state(old_state,new_state):
	if old_state==states.Attack:
		parent.hitShape.disabled=true
