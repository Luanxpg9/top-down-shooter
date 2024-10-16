extends CharacterBody2D
@onready var rack_sound: AudioStreamPlayer2D = $RackSound
@onready var shot_sound: AudioStreamPlayer2D = $ShotSound
@onready var ProjectileScene: PackedScene = preload("res://projectile.tscn")
const SPEED = 100
@onready var spawn_bullet: Node2D = $SpawnBullet

var can_shot:bool = false
var shot_anim_finished = true


func _physics_process(delta: float) -> void:
	_move()
	_rotate()
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("click_left"):
		shoot()

func _rotate()->void:
	var input_dir = Input.get_vector("a", "d", "w", "s")
	velocity = input_dir * SPEED

func _move()->void:
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var angle = direction.angle()
	rotation = angle
	
func shoot():
	if not can_shot:
		return
	
	shot_anim_finished = false
	can_shot = false
	shot_sound.play()
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	var angle_variation = 0.1  # Variação de ângulo em radianos

	# Calcula as direções com variação de ângulo
	var direction_left = direction.rotated(angle_variation)
	var direction_right = direction.rotated(-angle_variation)

	# Instancia os projéteis
	var projectile_instance = ProjectileScene.instantiate()
	var projectile_instance_left = ProjectileScene.instantiate()
	var projectile_instance_right = ProjectileScene.instantiate()

	# Define a posição inicial dos projéteis
	projectile_instance.position = spawn_bullet.global_position
	projectile_instance_left.position = spawn_bullet.global_position
	projectile_instance_right.position = spawn_bullet.global_position

	# Define a direção dos projéteis
	projectile_instance.direction = direction
	projectile_instance_left.direction = direction_left
	projectile_instance_right.direction = direction_right

	# Define a rotação dos projéteis
	projectile_instance.rotation = direction.angle()
	projectile_instance_left.rotation = direction_left.angle()
	projectile_instance_right.rotation = direction_right.angle()

	# Adiciona os projéteis à cena
	get_parent().add_child(projectile_instance)
	get_parent().add_child(projectile_instance_left)
	get_parent().add_child(projectile_instance_right)




func _on_ray_cast_2d_child_entered_tree(node: Node) -> void:
	print(1)
	pass # Replace with function body.


func _on_timer_fire_rate_timeout() -> void:
	if shot_anim_finished:
		can_shot = true

func _on_shot_sound_finished() -> void:
	rack_sound.play()

func _on_rack_sound_finished() -> void:
	shot_anim_finished = true
