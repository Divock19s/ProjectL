extends "res://stateMachine.gd"

var phase=1

func _ready():
	_add_state("Transition")
	_add_state("Idle")
	_add_state("Walk")
	_add_state("Charge")
	_add_state("Shoot")
	_add_state("Attack")
	_add_state("Jump")
	_add_state("Dead")
	call_deferred("_set_state",states.Idle)

func _state_logic(delta):
	_phases()
	if state!=states.Attack and state!=states.Shoot:
		if (sign(parent._detect())!=0 and parent.direction!=sign(parent._detect())):
			if parent._detectx()>10:
				parent._turn(sign(parent._detect()))
	if [states.Walk,states.Charge].has(state):
		parent._move()
	elif state==states.Jump:
		if parent.jamp:
			parent._jump(delta)
	parent._physics(delta)

func _get_transition(_delta):
	if parent.player.die:
		if state!=states.Idle:
			return states.Idle
	else:
		if phase==0:
			if state!=states.Dead:
				return states.Dead
		if phase==1:
			return _phase1()
		elif phase==2:
			return _phase2()
		elif phase==3:
			return _phase3()
	return null

func _enter_state(new_state,old_state):
	match state:
		states.Transition:
			parent.motion.x=0
			parent.transit=true
			parent.animation.play("transit")
		states.Dead:
			parent.play("Dead")
		states.Attack:
			parent.DetectTimer.start()
			parent.motion.x=0
			parent.attack=true
			parent.animation.play("Attack")
		states.Shoot:
			parent.BulletTimer.start()
			parent.motion.x=0
			parent.animation.play("Shoot")
		states.Idle:
			parent.motion.x=0
			parent.ChargeTimer.wait_time=12
			parent.ChargeTimer.start()
			parent.IdleTimer.wait_time=3
			parent.IdleTimer.start()
			parent.animation.play("Idle")
		states.Walk:
			parent.jumpCount=0
			parent.motion.x=0
			parent.speed=30
			if phase>1:
				parent.ShootTimer.wait_time=2
				parent.ShootTimer.start()
				if !parent.ChargeTimer.time_left<2 or parent.ChargeTimer.time_left==0:
					parent.ChargeTimer.wait_time=3
					parent.ChargeTimer.start()
			elif phase == 1:
				parent.IdleTimer.wait_time=6
				parent.IdleTimer.start()
			parent.animation.play("Move")
		states.Charge:
			parent.speed=100
			parent.motion.x=0
			parent.wallTimer.wait_time=4
			parent.wallTimer.start()
			parent.animation.play("Move")
		states.Jump:
			parent.jumpCount+=1
			parent._target()
			parent.jumpp=true
			parent.animation.play("Jump")

func _exit_state(old_state,new_state):
	match old_state:
		states.Charge:
			parent.jamp=true
		states.Attack:
			parent.battack=false
		states.Idle:
			parent.tim=true
		states.Walk:
			parent.tim=true

func _phase1():
	match state:
		states.Transition:
			if !parent.transit:
				return states.Charge
		states.Idle:
			if !parent.tim:
				return states.Walk
			elif parent._close() and parent.battack:
				return states.Attack
			elif parent.charge:
				return states.Transition
		states.Walk:
			if parent.charge:
				return states.Transition
			elif !parent.tim:
				return states.Idle
			elif parent._close() and parent.battack:
				return states.Attack
		states.Attack:
			if !parent.attack:
				return states.Walk
		states.Charge:
			if !parent.charge:
				return states.Idle
	return null

func _phase2():
	match state:
		states.Transition:
			if !parent.transit:
				return states.Charge
		states.Walk:
			if parent.charge:
				return states.Transition
			elif parent.shoot:
				return states.Shoot
			elif parent._close() and parent.battack:
				return states.Attack
		states.Attack:
			if !parent.attack:
				return states.Walk
		states.Shoot:
			if !parent.shoot:
				return states.Walk
			elif parent._close() and parent.battack:
				return states.Attack
		states.Charge:
			if !parent.charge:
				return states.Walk
		states.Idle:
			return states.Walk

func _phase3():
	match state:
		states.Transition:
			if !parent.transit:
				if parent.charge:
					return states.Charge
				elif parent.jamp:
					return states.Jump
		states.Jump:
			if parent.is_on_floor():
				if parent.jumpCount>=3:
					parent.jamp = false
					return states.Walk
				else:
					return states.Transition
		states.Walk:
			if parent.charge:
				return states.Transition
			elif parent.shoot:
				return states.Shoot
			elif parent._close() and parent.battack:
				return states.Attack
		states.Attack:
			if !parent.attack:
				return states.Walk
		states.Shoot:
			if !parent.shoot:
				return states.Walk
			elif parent._close() and parent.battack:
				return states.Attack
		states.Charge:
			if !parent.charge:
				return states.Transition
		states.Idle:
			return states.Walk

func _phases():
	if parent.health<=0:
		phase=0
	elif parent.health<300:
		phase=3
	elif parent.health<700:
		phase=2
