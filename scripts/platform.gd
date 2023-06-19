extends StaticBody2D

var speed = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get the position
	#var velocity = Vector2(0.0,speed * delta)
	#move_and_collide(velocity)
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
