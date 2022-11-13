extends StateMachine

func _ready():
	_add_state("Idle")
	_add_state("Run")
	_add_state("Slide")
	_add_state("WallSlide")
	_add_state("Dash")
	_add_state("Jump")
	_add_state("Fall")
	_add_state("Kick")
	_add_state("Crouch")
	_add_state("Stealth")
	_add_state("DoubleJump")
	_add_state("Shoot")
	_add_state("DownKick")
	_add_state("Hurt")
	_add_state("Dead")
	call_deferred("_set_state",states.Idle)

func _input(event):
	if !parent.die:
		if [states.Idle,states.Run].has(state):
			if event.is_action_pressed("ui_select"):
				if state==states.Idle:
					parent.kick=true
					_set_state(states.Kick)
				elif state==states.Run and abs(parent.motion.x)>5 and parent.slideable:
					parent.slideable=false
					parent._slide()
					parent._dash(parent.dashDirection,true)
					parent.dashTimer.start()
					parent.dash=true
					_set_state(states.Slide)
			elif event.is_action_pressed("ui_focus_next"):
				parent.motion.x=0
				parent.shoot=true
				_set_state(states.Shoot)
			if event.is_action_pressed("ui_up"):
				parent._jump(150)
			elif event.is_action_pressed("ui_down"):
				if state==states.Run and abs(parent.motion.x)>5 and parent.slideable:
					parent._slide()
					parent._dash(parent.dashDirection,true)
					parent.slideable=false
					parent.dashTimer.start()
					parent.dash=true
					_set_state(states.Slide)
				else:
					_set_state(states.Crouch)
					parent._crouch()
		elif state==states.DoubleJump:
			if event.is_action_pressed("ui_select") and parent.dashable:
				parent.sprite.rotation_degrees=0
				parent._dash(parent.dashDirection,false)
				parent.dashable=false
				parent.dash=true
				_set_state(states.Dash)
			elif event.is_action_pressed("ui_focus_next"):
				parent.downKick=true
				_set_state(states.DownKick)
		elif [states.Jump,states.Fall].has(state):
			if event.is_action_pressed("ui_select") and parent.dashable:
				parent._dash(parent.dashDirection,false)
				parent.dashable=false
				parent.dash=true
				_set_state(states.Dash)
			if event.is_action_pressed("ui_up"):
				_set_state(states.DoubleJump)
				parent._doubleJump(150)
			if state==states.Jump:
				if event.is_action_released("ui_up"):
					parent._jump(parent.motion.y/2)
		elif state==states.WallSlide:
			if event.is_action_pressed("ui_up"):
				parent.gravity = 500
				parent._wallJump(100)
			elif event.is_action_pressed("ui_left") and parent._rightWall():
				parent.wallSlideTimer.start()
			elif event.is_action_pressed("ui_right") and parent._leftWall():
				parent.wallSlideTimer.start()
			if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
				parent.wallSlideTimer.stop()
		elif [states.Stealth,states.Crouch].has(state):
			if event.is_action_released("ui_down"):
				parent.crouched=false
			elif event.is_action_pressed("ui_down"):
				parent.crouched=true

func _state_logic(delta):
	if !parent.die:
		var direction=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
		if ![states.WallSlide,states.Dash,states.Kick,states.Slide].has(state):
			parent._direction(direction)
		else:
			pass
		if [states.Idle,states.Run,states.Crouch,states.Stealth].has(state):
			if parent.dashable==false:
				parent.dashable=true
			if direction !=0:
				parent.side=direction
			parent._walk(direction)
		elif [states.DoubleJump,states.Jump,states.Fall,states.DownKick].has(state):
			parent._air(direction)
			if [states.DoubleJump,states.DownKick].has(state):
				parent.sprite.rotation_degrees+=30*parent.side
		elif state==states.Shoot:
			parent._bullet()
	else:
		if state!=states.Dead:
			_set_state(states.Dead)
	parent._physics(parent.gravity,delta)

func _get_transition(delta):
	match state:
		states.Idle:
			if !parent.is_on_floor():
				if parent.motion.y>1:
					return states.Fall
				else:
					return states.Jump
			elif parent.motion.x!=0:
				return states.Run
		states.Run:
			if !parent.is_on_floor():
				if parent.motion.y>0:
					return states.Fall
				else:
					return states.Jump
			elif parent.motion.x==0:
				return states.Idle
		states.Jump:
			if parent.is_on_floor():
				return states.Idle
			elif parent._leftWall() or parent._rightWall():
				parent._wallSlide()
				return states.WallSlide
			elif parent.motion.y>0:
				return states.Fall
		states.DoubleJump:
			if parent.is_on_floor():
				parent.sprite.rotation_degrees=0
				return states.Idle
			elif parent._leftWall() or parent._rightWall():
				parent._wallSlide()
				parent.sprite.rotation_degrees=0
				return states.WallSlide
		states.Crouch:
			if !parent._roof():
				if !parent.crouched:
					parent._uncrouch()
					return states.Idle
				elif !parent.is_on_floor():
					parent._uncrouch()
					return states.Fall
			if parent.motion.x!=0:
				return states.Stealth
		states.Stealth:
			if !parent._roof():
				if !parent.crouched:
					parent._uncrouch()
					return states.Idle
				elif !parent.is_on_floor():
					parent._uncrouch()
					return states.Fall
			if parent.motion.x==0:
				return states.Crouch
		states.Kick:
			if !parent.kick:
				if parent.is_on_floor():
					return states.Idle
				else:
					if parent.motion.y>0:
						return states.Fall
					else:
						return states.Jump
		states.Shoot:
			if !parent.shoot:
				if parent.is_on_floor():
					parent.bull=false
					return states.Idle
				else:
					if parent.motion.y>0:
						parent.bull=false
						return states.Fall
					else:
						parent.bull=false
						return states.Jump
			elif parent._leftWall() or parent._rightWall():
				parent.kick=false
				parent._wallSlide()
				parent.bull=false
				return states.WallSlide
		states.DownKick:
			if!parent.downKick:
				if parent.is_on_floor():
					parent.sprite.rotation_degrees=0
					return states.Idle
				elif parent._leftWall() or parent._rightWall():
					parent._wallSlide()
					parent.sprite.rotation_degrees=0
					return states.WallSlide
				else:
					return states.DoubleJump
		states.Fall:
			if parent.is_on_floor():
				return states.Idle
			elif parent._leftWall() or parent._rightWall():
				parent._wallSlide()
				return states.WallSlide
			else:
				if parent.motion.y<=0:
					return states.Jump
		states.WallSlide:
			if parent.is_on_floor():
				parent.gravity = 500
				return states.Idle
			else:
				if parent._leftWall()==false and parent._rightWall() == false:
					if parent.motion.y<=0:
						parent.gravity = 500
						return states.Jump
					elif parent.motion.y>0:
						parent.gravity = 500
						return states.Fall
		states.Dash:
			if !parent.dash:
				if parent.is_on_floor():
					parent._reset_attack()
					return states.Idle
				else:
					if parent.motion.y>0:
						parent._reset_attack()
						return states.Fall
					else:
						parent._reset_attack()
						return states.Jump
		states.Slide:
			if !parent.dash:
				if !parent._roof():
					if !parent.crouched:
						parent._uncrouch()
						return states.Idle
					elif !parent.is_on_floor():
						if parent._leftWall() or parent._rightWall():
							parent.dash=false
							parent._wallSlide()
							parent._uncrouch()
							return states.WallSlide
						parent.dash=false
						parent._uncrouch()
						return states.Fall
				if parent.motion.x==0:
					return states.Crouch
				elif parent.motion.x!=0:
					return states.Stealth
			elif !parent.is_on_floor():
				parent.slideable=true
				parent.dashTimer.stop()
				parent.dash=false
				parent._uncrouch()
				return states.Fall
		states.Hurt:
			pass
	return null
func _enter_state(new_state,old_state):
	match state:
		states.Idle:
			parent.label.text=("Idle")
			parent.plAnimation.play("Idle")
		states.Run:
			parent._RunDust()
			parent.runDustTimer.start()
			parent.label.text=("Run")
			parent.plAnimation.play("Run")
		states.Fall:
			parent.label.text=("Fall")
			parent.plAnimation.play("Fall")
		states.Jump:
			if [states.Idle,states.Run].has(old_state):
				parent.squash.play("Jump")
				parent._JumpDust()
			parent.label.text=("Jump")
			parent.plAnimation.play("Jump")
		states.DoubleJump:
			parent.label.text=("DoubleJump")
			parent.plAnimation.play("DoubleJump")
		states.WallSlide:
			parent.wallDustTimer.start()
			parent.label.text=("WallSlide")
			parent.plAnimation.play("WallSlide")
		states.Crouch:
			parent.label.text=("Crouch")
			parent.plAnimation.play("Crouch")
		states.Stealth:
			parent.label.text=("Stealth")
			parent.plAnimation.play("Stealth")
		states.Dash:
			parent._DashEffect()
			parent.dashEffectTimer.start()
			parent.label.text=("Dash")
			parent.plAnimation.play("AirKick")
		states.Slide:
			parent.kickShape.set_deferred("disabled",false)
			parent._SlideDust()
			parent.slideDustTimer.start()
			parent.label.text=("Slide")
			parent.plAnimation.play("Slide")
		states.Kick:
			parent.label.text=("Kick")
			parent.plAnimation.play("Kick")
		states.DownKick:
			parent.label.text=("DownKick")
			parent.plAnimation.play("DownKick")
		states.Shoot:
			parent.label.text=("Shoot")
			parent.plAnimation.play("Shoot")
		states.Dead:
			parent.motion.x=0
			parent.plAnimation.play("Death")

func _exit_state(old_state,new_state):
	match old_state:
		states.WallSlide:
			parent.wallDustTimer.stop()
		states.Run:
			parent.runDustTimer.stop()
		states.Fall:
			if [states.Idle,states.Run].has(new_state):
				parent.squash.play("Land")
				parent._LandDust()
		states.DoubleJump:
			if [states.Idle,states.Run].has(new_state):
				parent.squash.play("Land")
				parent._LandDust()
		states.Slide:
			parent.kickShape.set_deferred("disabled",true)
			parent.slideDustTimer.stop()
		states.Dash:
			parent.motion.x=clamp(parent.motion.x,-parent.walkSpeed,parent.walkSpeed)
			parent.dashEffectTimer.stop()
