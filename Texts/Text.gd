extends Area2D
export (bool) var remove=false
onready var textbox=get_parent().get_node("Player/CanvasLayer/Text")

func _ready():
	if Global.progress > 0:
		call_deferred("queue_free")

func _on_Text1_body_entered(body):
	if "Player" in body.name:
		textbox.Texts=["Come on i am going to get you out of here, are you in?","I know that you don't know me, but i promise that we share the same goal, follow me if you want to get to the spider"]
		textbox.textIndex=0
		textbox._start()
		if remove:
			$Timer.start()

func _on_Timer_timeout():
	call_deferred("queue_free")
