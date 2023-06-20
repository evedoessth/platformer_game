extends CharacterBody2D

signal game_over

@export var camera_path : NodePath
var camera


var width

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canMove = false

func _ready():
	camera = get_node(camera_path)

	width = get_viewport_rect().size.x

func _physics_process(delta):
	if canMove:
		if not is_on_floor():
			if $AnimatedSprite2D.animation != "Jump" and not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play("Fall")
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			$AnimatedSprite2D.play("Jump")
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			$AnimatedSprite2D.flip_h = direction < 0
			$AnimatedSprite2D.play("Walk")
			velocity.x = direction * SPEED
		else:
			$AnimatedSprite2D.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()



func _on_visible_on_screen_notifier_2d_screen_exited():
	var resolution = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

	if position.y > camera.position.y:
		game_over.emit()

	if position.x > camera.position.x and get_velocity().x > 0: 
		position = Vector2(-width/2-32, position.y)
		
	if position.x < 0 and get_velocity().x < 0:
		position = Vector2(width/2+32, position.y)

