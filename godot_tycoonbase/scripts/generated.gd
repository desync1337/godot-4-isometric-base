extends Node2D

#append yourself to nobuild otherwise we're gonna have problems!
func _ready() -> void:
	G.nobuild.append(position * 0.1)
