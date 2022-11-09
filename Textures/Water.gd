extends TileMap

export (int) var width=24
var pos=0
onready var splash=preload ("res://Effects/WaterSplash.tscn")

func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		pos = body.position.x-position.x
		if pos < 16:
			pos = 12
		elif pos > width-16:
			pos=width-12
		var water = splash.instance()
		add_child(water)
		water.position.x=pos
		
