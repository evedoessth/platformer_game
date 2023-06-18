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
	
	randomize()
	platform_spawn = 0
	while platform_spawn > -30000:
		var new_platform = platform.instantiate()
		var rand_platform_pos = randi_range(-width/2,width/2)
		new_platform.set_position(Vector2(rand_platform_pos,platform_spawn))
		add_child(new_platform)
		platform_spawn -= randi_range(20,120)
	
func _process(delta):
	$HUD/RestartLabel.text = restartText % $RestartTimer.time_left
	

func _on_player_game_over():
	$ScoreTimer.stop()
	
	
	$Player.canMove = false
	$Player.position.x = $StartPosition.position.x
	$Player.position.y = $StartPosition.position.y - 4 #TODO: remove - 4
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



