extends Node3D


@onready var muzzle_flash: GPUParticles3D = $Pistol/MuzzleFlash
@onready var fire_sfx: AudioStreamPlayer = $FireSFX
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fire() -> void:
	fire_sfx.play()
	emit_muzzle_flash()
	animation_player.play("fire")

func emit_muzzle_flash() -> void:
	muzzle_flash.emitting = true
