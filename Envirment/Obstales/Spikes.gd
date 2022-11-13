extends Area2D

func _on_Spikes_body_entered(body):
	if "Player" in body.name:
		print("entered")
