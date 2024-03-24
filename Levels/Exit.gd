extends Node3D

@export var next_level: PackedScene


func _on_exit_area_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_packed(next_level)
