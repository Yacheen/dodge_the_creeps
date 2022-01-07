extends Node

export (PackedScene) var Mob
export var should_reset_character = false
var score = 0

func _ready():
	randomize()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()

func new_game():
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	$YourAdc/CollisionShape2D.set_deferred("disabled", false)
	$YourAdc.start(Vector2(240, 540))
	$StartTimer.start()
	


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
	


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	var mob = Mob.instance()
	add_child(mob)

	var direction = $MobPath/MobSpawnLocation.rotation + PI/2

	mob.position = $MobPath/MobSpawnLocation.position

	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)



func _on_YourAdc_hit():
	game_over()
