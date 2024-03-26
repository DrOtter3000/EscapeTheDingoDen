extends Node3D


@onready var sfxopen = $SFXopen

var active: bool = true

func _on_area_3d_body_entered(body):
	if active:
		if body.is_in_group("Player"):
			if Gamestate.red_card == true:
				active = false
				sfxopen.play()
				var tween : Tween
				tween = create_tween()
				tween.tween_property(self, "position:x", position.x +1.95, 3.2)
	
	
