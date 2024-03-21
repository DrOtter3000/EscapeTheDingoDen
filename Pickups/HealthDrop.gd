extends Area3D

@export var healing_power: int = 15
var active: bool = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if active:
			active = false
			body.hitpoints += healing_power
			get_tree().call_group("HUD", "update_hitpoints")
			$AnimationPlayer.play("consume")
