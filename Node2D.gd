extends Node2D
var v=Vector2(20,20)
func _ready():
	v=v.clamped(10)
	print(str(v))
