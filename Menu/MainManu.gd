extends Control

onready var inn=$TweenIn
onready var outt =$TweenOut

var state
var states={"main":1, "options":2 , "controls":3}
var controls={"control1":1, "control2":2 , "control3":3}
var control
func _ready():
	$Options/VBoxContainer2/FullScreen.pressed=Global.FullScreen
	OS.window_fullscreen=Global.FullScreen
	$Label.visible=false
	$Label2.visible=false
	$Menu/VBoxContainer/Resume.grab_focus()
	if Global.progress==0:
		$Menu/VBoxContainer/Resume.text="New Game"
	else:
		$Menu/VBoxContainer/Resume.text="Resume"
	state=states.main
	control=controls.control1

func _process(_delta):
	match state:
		states.main:
			if $Label.visible:
				$Label.visible=false
			if $Label2.visible:
				$Label2.visible=false
			return
		states.options:
			if !$Label.visible:
				$Label.visible=true
			if $Label2.visible:
				$Label2.visible=false
			if Input.is_action_just_pressed("esc"):
				_change_state(states.main)
			return
		states.controls:
			if !$Label.visible:
				$Label.visible=true
			if !$Label2.visible:
				$Label2.visible=true
			if Input.is_action_just_pressed("esc"):
				_change_state(states.main)
			elif Input.is_action_just_pressed("ui_left"):
				_controls(false)
			elif Input.is_action_just_pressed("ui_right"):
				_controls(true)
			return

func _controls(right):
	match control:
		controls.control1:
			if right:
				control=controls.control2
				$Controls/Control2.anchor_left=1
				$Controls/Control2.anchor_right=2
				$Controls/Control3.anchor_left=1
				$Controls/Control3.anchor_right=2
				_enter_state($Controls/Control1,-1,0)
				_enter_state($Controls/Control2,0,1)
				return
			else:
				return
		controls.control2:
			if right:
				control=controls.control3
				_enter_state($Controls/Control2,-1,0)
				_enter_state($Controls/Control3,0,1)
				return
			else:
				control=controls.control1
				_enter_state($Controls/Control1,0,1)
				_enter_state($Controls/Control2,1,2)
				return
		controls.control3:
			if !right:
				control=controls.control2
				_enter_state($Controls/Control2,0,1)
				_enter_state($Controls/Control3,1,2)
				return
func _change_state(next_state):
	match state:
		states.main:
			if next_state==states.options:
				$Options/VBoxContainer2/Controls.grab_focus()
				_enter_state($Options,0,1)
				_enter_state($Menu,-1,0)
		states.options:
			if next_state==states.main:
				$Menu/VBoxContainer/Resume.grab_focus()
				_enter_state($Menu,0,1)
				_enter_state($Options,1,2)
			elif next_state==states.controls:
				$Controls/Control1.anchor_left=0
				$Controls/Control1.anchor_right=1
				_enter_state($Controls,0,1)
				_enter_state($Options,-1,0)
		states.controls:
			if next_state==states.main:
				$Menu/VBoxContainer/Resume.grab_focus()
				$Options.anchor_left=1
				$Options.anchor_right=2
				_enter_state($Menu,0,1)
				_enter_state($Controls,1,2)
	state=next_state
func _enter_state(menu,left,right):
	_tweenLeft(menu,left)
	_tweenRight(menu,right)

func _tweenLeft(objectt,destin):
	inn.interpolate_property(objectt,"anchor_left",
	objectt.anchor_left,destin,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	inn.start()

func _tweenRight(objectt,destin):
	outt.interpolate_property(objectt,"anchor_right",
	objectt.anchor_right,destin,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	outt.start()

func _on_Resume_pressed():
	if state==states.main:
		var _k = get_tree().change_scene("res://Story.tscn")


func _on_Reset_pressed():
	if state==states.main:
		pass


func _on_Options_pressed():
	if state==states.main:
		_change_state(states.options)


func _on_Quit_pressed():
	if state==states.main:
		get_tree().quit()


func _on_FullScreen_pressed():
	if state==states.options:
		OS.window_fullscreen=$Options/VBoxContainer2/FullScreen.pressed
		Global.FullScreen=$Options/VBoxContainer2/FullScreen.pressed


func _on_Music_pressed():
	if state==states.options:
		pass


func _on_Support_pressed():
	if state==states.options:
		pass


func _on_Controls_pressed():
	if state==states.options:
		_change_state(states.controls)
