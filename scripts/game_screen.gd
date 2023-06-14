extends Node2D

const restartText = "%1d"
@export var platform_scene: PackedScene

var score

func _ready():
	$Player.canMove = false
	$Player.position.x = $StartPosition.position.x
	$Player.position.y = $StartPosition.position.y
	
	$Platform.position.x = $StartPosition.position.x #TODO: remove
	$Platform.position.y = $StartPosition.position.y + 4 #TODO: remove
	
	$RestartTimer.start()
	$HUD/RestartLabel.visible = true
	$HUD/ScoreLabel.visible = false
	
	
func _process(delta):
	$HUD/RestartLabel.text = restartText % $RestartTimer.time_left
	

func _on_player_game_over():
	$ScoreTimer.stop()
	get_tree().call_group("platforms", "queue_free")
	
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
	$PlatformTimer.start()
	$Player.canMove = true
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_restart_timer_timeout():
	new_game()


func _on_platform_timer_timeout():
	var platform = platform_scene.instantiate()
	
	var platform_spawn_location = get_node("PlatformPath/PlatformSpawnLocation")
	platform_spawn_location.progress_ratio = randf()
	
	var direction = platform_spawn_location.rotation + PI / 2
	
	platform.position = platform_spawn_location.position
	
	
	add_child(platform)
