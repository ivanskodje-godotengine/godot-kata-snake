extends Node2D

func draw_background():
	var rect = Rect2(Vector2.ZERO, GameState.WINDOW_SIZE)
	var color = GameState.COLOR_1
	draw_rect(rect, color)

func _draw() -> void:
	draw_background()



