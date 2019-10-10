extends Area2D

export var speed :=  250

func _physics_process(delta: float) -> void:
	position.x += speed * delta

func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
		queue_free()

func _on_Bullet_body_entered(body: PhysicsBody2D) -> void:
	if body:
		queue_free()
		if body.is_in_group("Enemies"):
			body.destroyed()


