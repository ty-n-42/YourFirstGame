extends Area2D;

# Player dependencies:
# - get_viewport_rect()
# - Input.is_action_pressed()
# - body_entered signal - I'm not sure if this is emitted by Player (i.e. Area2D) or from the object that collides with Player

# signals
signal hit;

# member variables
export var speed: int = 400; # How fast the player will move (pixels/sec); exported so the value is modifiable in the Godot IDE
var screen_size: Vector2; # the size of the game window


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size; # cache the viewport rectangle size
	hide(); # hide the player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# note: how often this is called depends on how fast the device is that runs this code
	# Check for input
	var velocity = Vector2(); # the player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1;
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1;
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1;
		
	# Set direction usign the velocity vector: 8 directoions only
	# Play the appropriate animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed; # velocity.normalized() returns the unit length version of the vector
		$AnimatedSprite.play();
	else:
		$AnimatedSprite.stop();
	
	# Move in the given direction
	position += velocity * delta;
	# Restrict the player to the screen
	position.x = clamp(position.x, 0, screen_size.x); # improve by accounting for the sprite width
	position.y = clamp(position.y, 0, screen_size.y); # improve by accounting for the sprite height
	
	# Configure animation - improve by accounting for prior direction
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk";
		$AnimatedSprite.flip_v = false;
		$AnimatedSprite.flip_h = velocity.x < 0; # assigns the boolean result of the comparision
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up";
		$AnimatedSprite.flip_v = velocity.y > 0; # assigns the boolean result of the comparison


# Configure the Player to start playing
func start(pos: Vector2):
	position = pos; # set the player position
	show(); # make the player visible
	#$CollisionShape2D.disabled = false; # enable collisions
	$CollisionShape2D.set_deferred("disabled", false); # start reacting to collisions


# Signal received when a RigidBody2D node enters this node's Area2D hitbox
func _on_Player_body_entered(body):
	hide(); # Player disappears
	emit_signal("hit"); # emit the custom `hit` signal notifying that Player was hit
	$CollisionShape2D.set_deferred("disabled", true); # stop reacting to collisions to prevent duplicate signal emission
