extends Node2D


func _on_coalfac_button_up() -> void:
	G.selectbuild = "coal"
	visible = false


func _on_warehouse_button_up() -> void:
	G.selectbuild = "warehouse"
	visible = false
