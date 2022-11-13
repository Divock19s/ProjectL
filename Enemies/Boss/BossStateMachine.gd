extends "res://stateMachine.gd"

var health=1000
var phase=1

func _ready():
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
	if state!=states.Attack:
		if (sign(parent._detect())!=0 and parent.direction!=sign(parent._detect())):
			parent._turn(sign(parent._detect()))
	if [states.Walk,states.Charge].has(state):
		parent._move()
	elif state==states.Jump:
		if parent.jamp:
			parent._jump(delta)
	parent._physics(delta)

func _get_transition(_delta):
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
		states.Dead:
			parent.play("Dead")
		states.Attack:
			parent.DetectTimer.start()
			parent.motion.x=0
			parent.attack=true
			parent.animation.play("Attack")
		states.Shoot:
			parent.animation.play("Shoot")
		states.Idle:
			parent.motion.x=0
			parent.ChargeTimer.wait_time=12
			parent.ChargeTimer.start()
			parent.IdleTimer.wait_time=3
			parent.IdleTimer.start()
			parent.animation.play("Idle")
		states.Walk:
			parent.speed=30
			parent.motion.x=0
			parent.IdleTimer.wait_time=6
			parent.IdleTimer.start()
			parent.animation.play("Move")
		states.Charge:
			parent.speed=100
			parent.motion.x=0
			parent.ChargeTimer.wait_time=3
			parent.ChargeTimer.start()
			parent.animation.play("Move")
		states.Jump:
			parent.jumpp=true
			parent.animation.play("Jump")

func _exit_state(old_state,new_state):
	match old_state:
		states.Attack:
			parent.battack=false
		states.Idle:
			parent.tim=true
		states.Walk:
			parent.tim=true
		states.Jump:
			parent.jamp=false

func _phase1():
	match state:
		states.Idle:
			if !parent.tim:
				return states.Walk
			elif parent._close() and parent.battack:
				return states.Attack
			elif parent.charge:
				return states.Charge
		states.Walk:
			if parent.charge:
				return states.Charge
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
		states.Walk:
			if parent.shoot:
				return states.Shoot
			elif parent._close():
				return states.Attack
			elif parent.charge:
				return states.Charge
		states.Attack:
			if !parent.attack:
				return states.Walk
		states.Shoot:
			if parent._close():
				return states.Attack
			elif parent.charge:
				return states.Charge
		states.Charge:
			if !parent.charge:
				return states.Walk

func _phase3():
	match state:
		states.Walk:
			if parent.shoot:
				return states.Shoot
			elif parent._close():
				return states.Attack
			elif parent.jump:
				return states.Jump
			elif parent.charge:
				return states.Charge
		states.Attack:
			if !parent.attack:
				return states.Walk
		states.Shoot:
			if parent._close():
				return states.Attack
			elif parent.charge:
				return states.Charge
		states.Charge:
			if !parent.charge:
				return states.Walk
func _phases():
	if health<=0:
		phase=0
	elif health<300:
		phase=3
	elif health<700:
		phase=2
