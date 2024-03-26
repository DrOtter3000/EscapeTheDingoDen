extends Area3D


@onready var animation_player = $AnimationPlayer

var collected: bool = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if not collected:
			collected = true
			Gamestate.green_card = true
			animation_player.play("die")
			
