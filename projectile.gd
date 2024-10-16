extends Area2D

@onready var collision: CollisionShape2D = $Collision

var speed = 4000 
var direction = Vector2.ZERO  


func _physics_process(delta: float):
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	pass
	#queue_free()
