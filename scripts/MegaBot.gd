extends KinematicBody2D

signal player_has_died

export var speed := 120
export var gravity := 1200
export var jump_force := 300
export (PackedScene) var bullet

var velocity := Vector2.ZERO
var shooting := false
var can_shoot := true
var state_machine
var dead := false

func _ready() -> void:
	state_machine = $AnimationTree.get("parameters/playback")

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func get_input() -> void:
	var h = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = speed * h
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force
	if Input.is_action_pressed("ui_cancel") and can_shoot:
		shoot()
	if !Input.is_action_pressed("ui_cancel"):
		can_shoot = true

func update_animation() -> void:
	state_machine.travel("idle")
	if abs(velocity.x) > 0:
		$Sprite.flip_h = velocity.x < 0
		state_machine.travel("run")
	if !can_shoot and abs(velocity.x) == 0:
		state_machine.travel("shot")
	if shooting and abs(velocity.x) > 0:
		state_machine.travel("run_and_shoot")
	if !is_on_floor():
		state_machine.travel("jump")
	if dead:
		state_machine.travel("dead")
		set_physics_process(false)
		$CollisionShape2D.disabled = true

func death() -> void:
	dead = true
	yield(get_tree().create_timer(2),"timeout")
	emit_signal("player_has_died")

func shoot() -> void:
	can_shoot = false
	shooting = true
	var b = bullet.instance()
	b.speed *= -1 if $Sprite.flip_h else 1
	$Position2D.position.x = -14 if $Sprite.flip_h else 14
	b.position = $Position2D.global_position
	$BulletTime.start()
	get_parent().add_child(b)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	get_input()
	update_animation()
	if position.y > 250:
		death()
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_BulletTime_timeout() -> void:
	shooting = false