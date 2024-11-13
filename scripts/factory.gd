extends Node2D

@export var item : String

func _on_timer_timeout() -> void:
	match item:
		"coal":
			G.coal += 1
		"iron":
			G.iron += 1
	$AnimationPlayer.play("auto")
