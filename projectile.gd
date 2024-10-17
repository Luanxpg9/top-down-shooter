extends Area2D

@onready var collision: CollisionShape2D = $Collision

var speed = 4000
var direction = Vector2.ZERO  


func _physics_process(delta: float):
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("projectile"):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == 'paredes':
		queue_free()
	
