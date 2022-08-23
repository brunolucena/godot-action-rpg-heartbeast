extends KinematicBody2D
class_name Bat

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE,
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var stats = $"%Stats"
onready var player_detection_zone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			chase_state(delta)
	
	sprite.flip_h = velocity.x < 0

func chase_state(delta: float):	
	var player = player_detection_zone.player
	if player != null:
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
		velocity = move_and_slide(velocity)
	else:
		state = IDLE

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area: Area2D):
	if area is SwordHitbox:
		stats.health -= area.damage
		knockback = area.knockback_vector * 120

func _on_Stats_no_health():
	queue_free()
	var enemy_death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
