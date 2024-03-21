extends Control


func update_hitpoints() -> void:
	var new_health = get_tree().get_first_node_in_group("Player").hitpoints
	$HealthBar.value = new_health
