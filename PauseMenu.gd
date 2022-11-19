extends Control

func _ready():
	visible=false
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused=!get_tree().paused
		if get_tree().paused:
			visible=true
			$CenterContainer/VBoxContainer/Resume.grab_focus()
		else:
			visible=false
func _death():
	pass
func _on_Resume_pressed():
	get_tree().paused=false
	visible=false

func _on_Map_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
