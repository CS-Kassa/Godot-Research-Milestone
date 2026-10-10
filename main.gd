
extends Control

var score = 0
var time_left = 15
var playing = false
var high_score = 0

var score_label: Label
var timer_label: Label
var message_label: Label
var target: Button
var start_button: Button
var difficulty: OptionButton
var game_timer: Timer


func _ready():
	score_label = Label.new()
	score_label.position = Vector2(30, 20)
	add_child(score_label)

	timer_label = Label.new()
	timer_label.position = Vector2(30, 55)
	add_child(timer_label)

	message_label = Label.new()
	message_label.position = Vector2(30, 90)
	message_label.text = "Choose a difficulty and start!"
	add_child(message_label)

	difficulty = OptionButton.new()
	difficulty.position = Vector2(30, 135)
	difficulty.add_item("Easy")
	difficulty.add_item("Medium")
	difficulty.add_item("Hard")
	add_child(difficulty)

	start_button = Button.new()
	start_button.text = "Start Game"
	start_button.position = Vector2(30, 185)
	add_child(start_button)
	start_button.pressed.connect(start_game)

	target = Button.new()
	target.text = "CLICK!"
	add_child(target)
	target.hide()
	target.pressed.connect(hit_target)

	game_timer = Timer.new()
	game_timer.wait_time = 1.0
	add_child(game_timer)
	game_timer.timeout.connect(update_timer)

	update_labels()


func start_game():
	score = 0
	time_left = 15
	playing = true

	start_button.hide()
	difficulty.disabled = true
	message_label.text = "Hit as many targets as you can!"

	match difficulty.selected:
		0:
			target.size = Vector2(110, 70)
		1:
			target.size = Vector2(80, 50)
		2:
			target.size = Vector2(55, 40)

	target.show()
	move_target()
	game_timer.start()
	update_labels()


func hit_target():
	if not playing:
		return

	score += 1
	update_labels()
	move_target()


func move_target():
	var screen_size = get_viewport_rect().size
	var max_x = int(screen_size.x - target.size.x - 20)
	var max_y = int(screen_size.y - target.size.y - 20)

	var x = randi_range(20, max(20, max_x))
	var y = randi_range(260, max(260, max_y))

	target.position = Vector2(x, y)


func update_timer():
	time_left -= 1
	update_labels()

	if time_left <= 0:
		end_game()


func end_game():
	playing = false
	game_timer.stop()
	target.hide()
	start_button.show()
	start_button.text = "Play Again"
	difficulty.disabled = false
	
	if score > high_score:
		high_score = score
		message_label.text = "New High Score: " + str(score)
	else:
		message_label.text = "Final Score: " + str(score) + " | Best: " + str(high_score)

func update_labels():
	score_label.text = "Score: " + str(score)
	timer_label.text = "Time Remaining: " + str(time_left)
