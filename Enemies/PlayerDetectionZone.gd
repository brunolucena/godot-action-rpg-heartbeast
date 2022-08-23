extends Area2D

var player: Player = null


func can_see_player() -> bool:
	return player != null

func _physics_process(delta):
	pass

func _on_PlayerDetectionZone_body_entered(body):
	if body is Player:
		player = body

func _on_PlayerDetectionZone_body_exited(body):
	if body is Player:
		player = null
