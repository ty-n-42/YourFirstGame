extends Node

# Potential enhancements
# Main is using the interfaces of its children.  By doing that it increases the scope
#  of change required when refactoring the children.  A less coupled approach may 
#  make refactoring easier.
#  e.g. score_changed signal and update_score(score: int) method
#  e.g. game_over singal and signal emision in the game_over() method 
# There are also structural dependencies that could be reduced using some of the
#  best practices that are documented in the Godot documentation

# External Dependencies
# - 

# show Mob in the Godot IDE
export (PackedScene) var Mob: PackedScene; # allow the mob to be selected in the Godot IDE
var score: int; # score the player obtains

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize(); # initialise the random number generator - relied on by the Mob scene.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over() -> void:
	$ScoreTimer.stop(); # stop the score timer so the player doesn't get any more score
	$MobTimer.stop(); # stop the mob timer so enemies stop spawning
	$HUD.show_game_over(); # display the game over HUD and allow user to start a new game
	get_tree().call_group("mobs", "queue_free"); # free all the mob instances


# Receive hit signal from Player 
func _on_Player_hit():
	# the game is now over
	game_over();


# initialise and start a new game
# called when a start game signal is received from HUD
func new_game() -> void:
	score = 0; # initialise the score to 0
	
	$HUD.update_score(score); # why isn't HUD listening for a score change event instead?
	$HUD.show_message("Get Ready"); # this is confusing because it has the side effect of starting the game 
	
	$Player.start($StartPosition.position); # configure the player to start playing
	$StartTimer.start(); # trigger the start of the game in a moment 


# Receive timeout signal from MobTimer
func _on_MobTimer_timeout():
	# spawn an enemy in a random location on the MobPath
	var mob = Mob.instance(); # create an instance of Mob
	add_child(mob); # add the new instance of Mob to the scene
	
	$MobPath/MobSpawnLocation.offset = randi(); # choose random location along MobPath
	# create a direction perpendicular to the random path location
	var direction: float = $MobPath/MobSpawnLocation.rotation + PI / 2;
	direction += rand_range(-PI / 4, PI / 4); # add some randomness to the direction
	
	mob.position = $MobPath/MobSpawnLocation.position; # set the mob instances' position
	mob.rotation = direction; # set the mob instances' rotation
	# set the mob linear velocity somewhere between min and max speed
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0);
	mob.linear_velocity = mob.linear_velocity.rotated(direction); # rotate the linear velocity to give it direction


# Receive timeout signal from ScoreTimer
func _on_ScoreTimer_timeout():
	score += 1; # increment the player score
	$HUD.update_score(score); # update the score in the HUD


# Receive timeout signal from StartTimer
func _on_StartTimer_timeout():
	$ScoreTimer.start(); # start the score timer - incrementing player score
	$MobTimer.start(); # start the mob timer - spawning enemies


# receive start game signal from HUD
# initialise and start a new game
func _on_HUD_start_game():
	new_game();
