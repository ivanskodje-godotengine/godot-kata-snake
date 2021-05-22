extends Node2D

onready var tick_timer = $"../TickTimer"
onready var food_spawn_timer = $"../FoodSpawnTimer"
onready var highscore_current : Label = $"../CanvasLayer/HUD/HighScoreCurrent"
onready var game_over_window : ColorRect = $"../CanvasLayer/HUD/GameOverWindow"
onready var tick_count_label : Label = $"../CanvasLayer/HUD/TickCount"
var snake_direction : Vector2 = Vector2.RIGHT
var snake_body_positions = []
var food_positions = []

var head_color = GameState.COLOR_4
var body_color = GameState.COLOR_3
var food_color = GameState.COLOR_2


func _ready() -> void:
	create_game()

func create_game():
	tick_timer.wait_time = 0.25
	tick_timer.stop()
	food_spawn_timer.stop()
	highscore_current.text = "0"
	tick_count_label.text = "0"

	snake_body_positions.clear()
	snake_body_positions.append(Vector2(20, 18))
	snake_body_positions.append(Vector2(20, 18))
	snake_body_positions.append(Vector2(20, 18))
	snake_body_positions.append(Vector2(20, 18))

	food_positions.clear()
	food_positions.append(Vector2(randi() % 40, randi() % 36))

var current_snake_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if(GameState.current_state == "playing"):
		if(Input.is_action_just_pressed("ui_up") && can_move_up()):
			snake_direction = Vector2.UP
		elif(Input.is_action_just_pressed("ui_down") && can_move_down()):
			snake_direction = Vector2.DOWN
		elif(Input.is_action_just_pressed("ui_left") && can_move_left()):
			snake_direction = Vector2.LEFT
		elif(Input.is_action_just_pressed("ui_right") && can_move_right()):
			snake_direction = Vector2.RIGHT

		if(Input.is_action_just_pressed("ui_cancel")):
			GameState.current_state = "stopped"

	elif(GameState.current_state == "stopped"):

		tick_timer.stop()
		food_spawn_timer.set_paused(true)

		if(has_pressed_key()):
			print("Starting Game")
			GameState.current_state = "playing"
			tick_timer.start()
			food_spawn_timer.set_paused(false)
			food_spawn_timer.start()
	elif(GameState.current_state == "game_over"):
		game_over_window.show()
		if(has_pressed_key()):
			print("Resetting new game")
			GameState.current_state = "stopped"
			create_game()
			game_over_window.hide()
			tick_timer.stop()
			food_spawn_timer.stop()
			food_spawn_timer.set_paused(false)
			update()



func has_pressed_key():
	return Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_up") \
		|| Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down") \
		|| Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right")

func _draw() -> void:
	if(!will_collide()):
		move_snake()
		try_eat_food()
		increase_time_played()
	else:
		GameState.current_state = "game_over"
		print("Game Over!")

	draw_food()
	draw_snake()


func draw_snake():
	draw_pixel(snake_body_positions[0], head_color)
	for i in range(1, snake_body_positions.size()-1):
		draw_pixel(snake_body_positions[i], body_color)

func draw_food():
	for food_position in food_positions:
		draw_pixel(food_position, food_color)

func move_snake():
	for i in range(snake_body_positions.size()-1, 0, -1):
		snake_body_positions[i] = snake_body_positions[i-1]
	snake_body_positions[0] += snake_direction
	current_snake_direction = snake_direction

func try_eat_food():
	var snake_head_position = snake_body_positions[0]

	for i in range(food_positions.size()):
		if(food_positions[i] == snake_head_position):
			print("Nomnom")
			food_positions.remove(i)
			snake_body_positions.append(snake_body_positions[snake_body_positions.size()-1])
			add_points(12500)
			increase_snake_speed()
			break

func increase_snake_speed():
	tick_timer.wait_time -= tick_timer.wait_time * 0.1

func add_points(points : int):
	highscore_current.text = str(int(highscore_current.text) + points)

func will_collide():
	return will_collide_with_edge() || will_collide_with_self()

func will_collide_with_edge() -> bool:
	var future_position = snake_body_positions[0] + snake_direction
	return (future_position.x < 0 || future_position.x >= 40) \
	|| (future_position.y < 0 || future_position.y >= 36)

func will_collide_with_self() -> bool:
	var future_position = snake_body_positions[0] + snake_direction
	return snake_body_positions.has(future_position)

func draw_pixel(position : Vector2, color : Color):
	var rect = Rect2(position * GameState.PIXEL_SIZE, GameState.PIXEL_SIZE)
	draw_rect(rect, color)

func _on_timer_timeout() -> void:
	update()

func increase_time_played():
	tick_count_label.text = str(int(tick_count_label.text) + 1)

	add_points(100)


func can_move_up() -> bool:
	return current_snake_direction != Vector2.DOWN

func can_move_down() -> bool:
	return current_snake_direction != Vector2.UP

func can_move_left() -> bool:
	return current_snake_direction != Vector2.RIGHT

func can_move_right() -> bool:
	return current_snake_direction != Vector2.LEFT


func _on_food_spawn_timer_timeout() -> void:
	print("asdsa")
	food_positions.append(Vector2(randi() % 40, randi() % 36))
