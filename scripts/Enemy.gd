extends KinematicBody2D

var fly_speed := -50
var velocity := Vector2.ZERO
var player = null
var is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
		queue_free()
	if player:
		velocity = (position - player.position).normalized() * fly_speed
	else:
		velocity.x = fly_speed

	$AnimatedSprite.flip_h = velocity.x > 0

	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("death"):
			collision.collider.death()


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body:
		if body.get_name() == "MegaBot":
			player = body

func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	if body:
		if body.get_name() == "MegaBot":
			player = null


func destroyed() -> void:
	$AnimatedSprite.play("dead")
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(4, false)
	set_physics_process(false)
	yield(get_tree().create_timer(1),"timeout")
	hide()
	is_dead = true


