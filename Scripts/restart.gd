extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(_body: CharacterBody3D) -> void:
	if(!_body.is_in_group("player")): return 
	await get_tree().process_frame
	get_tree().reload_current_scene()
