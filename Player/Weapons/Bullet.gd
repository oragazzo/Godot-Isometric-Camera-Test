extends Node3D

@export var speed = 70

@export var kill_time = 4
var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)

	timer += delta
	if timer >= kill_time:
		# Add some animation or side effect on bullet end
		on_bullet_end()

func on_bullet_end():
	queue_free()
