extends CanvasLayer

# External dependencies
# - some other object must start the game after the start_game signal is sent
# - Main uses update_score() whenever the score changes


# signal to emit to notify that the game should start
# emitted when the start button is pressed
signal start_game; # interesting name since most of the time signals are past tense


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# display text as a message and start the coutdown timer for it to be hidden 
func show_message(text: String):
	$Message.text = text;
	$Message.show();
	$MessageTimer.start(); # would be more understandable with an inline yield


# receive timeout signal from MessageTimer
# hide the message
func _on_MessageTimer_timeout():
	$Message.hide();


# display a game end message for a few moments then the game title
# and a moment later the start button
func show_game_over():
	# display the game over message
	show_message("Game Over");
	# wait until the message timer has timed out
	yield($MessageTimer, "timeout");
	
	# display the game title
	$Message.text = "Dodge the\nCreeps!"
	$Message.show();
	
	# make a one-shot timer and wait for it to finish
	yield( get_tree().create_timer(1), "timeout" ); # does this node get destroyed automagically?
	$StartButton.show();


# update the score label with the value of score
func update_score(score):
	$ScoreLabel.text = str(score);


# receive the pressed signal from StartButton
# hide the start button and emit the start game signal
func _on_StartButton_pressed():
	$StartButton.hide();
	emit_signal("start_game");

