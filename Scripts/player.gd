extends CharacterBody2D
@onready var rack_sound: AudioStreamPlayer2D = $Audios/RackSound
@onready var shot_sound: AudioStreamPlayer2D = $Audios/ShotSound
@onready var footstep_sound: AudioStreamPlayer2D = $Audios/FootstepSound
@onready var point_light_2d_2_player: PointLight2D = $PointLight2D2Player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var explosion: GPUParticles2D = $Explosion

@onready var ProjectileScene: PackedScene = preload("res://projectile.tscn")
const SPEED = 100
@onready var spawn_bullet: Node2D = $SpawnBullet

var can_shot:bool = false
var shot_anim_finished = true
var can_walk_sound = false

func _ready() -> void:
	animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	_move()
	_rotate()
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("click_left"):
		shoot()

func _move()->void:
	var input_dir = Input.get_vector("a", "d", "w", "s")
	if input_dir == Vector2.ZERO:
		can_walk_sound = false
		#animated_sprite_2d.play("idle")
	elif not footstep_sound.playing:
		if !animated_sprite_2d.is_playing():
			animated_sprite_2d.play("move")
		can_walk_sound = true
	_sound_walking()
	velocity = input_dir * SPEED

func _rotate()->void:
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var angle = direction.angle()
	rotation = angle
	point_light_2d_2_player.rotation = -angle
	
	
func shoot():
	if not can_shot:
		return
	explosion.emitting = true
	shot_anim_finished = false
	can_shot = false
	animated_sprite_2d.play("shot")
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
	


func _sound_walking():
	if can_walk_sound and not footstep_sound.playing:
		footstep_sound.play()

func _on_timer_fire_rate_timeout() -> void:
	explosion.emitting = false
	if shot_anim_finished:
		can_shot = true

func _on_shot_sound_finished() -> void:
	rack_sound.play()
	animated_sprite_2d.play("reload")

func _on_rack_sound_finished() -> void:
	shot_anim_finished = true

func _on_footstep_sound_finished() -> void:
	can_walk_sound = true
