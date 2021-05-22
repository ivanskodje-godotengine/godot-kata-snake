extends Control

onready var pixel = Window.PIXEL_SIZE
onready var draw : Draw = Draw.new(self)

var player_position = Vector2(80, 72)
var previous_position = null
var player_direction = Vector2.DOWN
var player_body = []

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_up")):
		player_direction = Vector2.UP
	elif(Input.is_action_just_pressed("ui_down")):
		player_direction = Vector2.DOWN
	elif(Input.is_action_just_pressed("ui_right")):
		player_direction = Vector2.RIGHT
	elif(Input.is_action_just_pressed("ui_left")):
		player_direction = Vector2.LEFT


# 652 2 33 5 1
func move_player():
	previous_position = player_position
	player_position = player_position + player_direction * pixel

	if(GameState.is_food(player_position)):
		player_body.append(previous_position)
		GameState.remove_food(player_position)
	else:
		for i in range(0, player_body.size() - 1):
			var index = player_body.size() - i
			player_body[index] = player_body[index-1]

func _on_timer_timeout() -> void:
	move_player()
	update()

func _draw() -> void:
	draw_player()
	draw_body()

func draw_player():
	var body_color = Colors.GREEN_BRIGHTEST
	draw.draw_block(body_color, player_position, Vector2(pixel, pixel))


func draw_body():
	for body in player_body:
		var body_color = Colors.GREEN_BRIGHT
		draw.draw_block(body_color, body, Vector2(pixel, pixel))
