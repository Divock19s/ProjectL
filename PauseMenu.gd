extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
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
func _on_Resume_pressed():
	get_tree().paused=false
	visible=false


func _on_Map_pressed():
	pass # Replace with function body.


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
