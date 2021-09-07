extends RigidBody2D

# External Dependencies:
# - randomize() is used in the Main scene so it isn't duplicated here

# exported variables appear in the Godot IDE
# min and max speed for randomly selecting spawned enemy speed
export var min_speed: int = 150; # minimum speed range
export var max_speed: int = 250; # maximum speed range

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# get an array containing all the mob animation names
	var mob_types: PoolStringArray = $AnimatedSprite.frames.get_animation_names();
	# randomly pick one of the names to define which animation to play
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()];


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# screen_exited signal received from VisibilityNotifier2D
func _on_VisibilityNotifier2D_screen_exited():
	queue_free(); # delete instance when Godot is sure it's ok
