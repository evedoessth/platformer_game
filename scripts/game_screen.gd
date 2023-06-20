extends Node2D

const restartText = "%1d"
@export var platform_scene: PackedScene
var platform = preload("res://scenes/platform.tscn")

var width
var score
var platform_spawn

func _ready():
	width = get_viewport_rect().size.x
	$Player.canMove = false
	#$Player.position.x = $StartPosition.position.x
	#$Player.position.y = $StartPosition.position.y
	
	$RestartTimer.start()
	$HUD/RestartLabel.visible = true
	$HUD/ScoreLabel.visible = false
	
	spawn_platforms()

func _process(delta):
	$HUD/RestartLabel.text = restartText % $RestartTimer.time_left
	

func _on_player_game_over():
	$ScoreTimer.stop()
	
	#destroy all platforms
	get_tree().call_group("platforms", "queue_free")
	
	$Player.canMove = false
	$GameCamera.position = Vector2(0,0)
	create_start_platform()
	$Player.position.x = 0
	$Player.position.y = 0 
	
	#recreate the platforms
	spawn_platforms()
	
	$Player/AnimatedSprite2D.flip_h = false
	$Player/AnimatedSprite2D.animation = "Idle"
	$Player/AnimatedSprite2D.stop()
	
	$RestartTimer.start()
	$HUD/RestartLabel.visible = true
	$HUD/ScoreLabel.visible = false
	
	
func new_game():
	score = 0
	$HUD.update_score(score)
	
	$HUD/RestartLabel.visible = false
	$HUD/ScoreLabel.visible = true
	
	$ScoreTimer.start()
	$Player.canMove = true
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_restart_timer_timeout():
	new_game()

func create_start_platform():
	var spawn_platform = platform.instantiate()
	spawn_platform.position = Vector2(0,6)
	add_child(spawn_platform)

func spawn_platforms():
	randomize()
	platform_spawn = 0
	while platform_spawn > -30000:
		var new_platform = platform.instantiate()
		var rand_platform_pos = randi_range(-width/2,width/2)
		new_platform.set_position(Vector2(rand_platform_pos,platform_spawn))
		

		# Diese Funktion will nicht und wir haben nicht herausgefunden warum sie nur die erste Platfrom animiert
		randomize()
		var randmove = randi_range(0,6)
		if (randmove == 5):
			new_platform.get_node("AnimationPlayer").play("horizontal_movement")
		
		add_child(new_platform)
		
		platform_spawn -= randi_range(20,90)

