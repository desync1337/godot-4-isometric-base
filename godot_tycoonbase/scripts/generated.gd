extends Node2D

@export var price = 50

#append yourself to nobuild otherwise we're gonna have problems!
func _ready() -> void:
	if get_parent().nobuild.has(position):
		queue_free()
	else:
		get_parent().nobuild.append(position)
