extends Node3D

@export var speed = 70

const KILL_TIME = 0.5
var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)

	timer += delta
	if timer >= KILL_TIME:
		queue_free()
