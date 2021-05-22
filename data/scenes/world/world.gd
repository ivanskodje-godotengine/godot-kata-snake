extends Control

var pixel

onready var draw : Draw = Draw.new(self) # WRONG ERROR; DUMB GODOT

var food_position = null

func _ready() -> void:
	# Create food
	randomize()
	food_position = Vector2(randi() % 15*4, randi() % 15 * 4)
	GameState.add_food(food_position)

	self.pixel = Window.PIXEL_SIZE

func _physics_process(delta: float) -> void:
	update()

func _draw() -> void:
	var center = Vector2(60, 60)
	draw_background()
	draw_window_borders()
	draw_food()


func draw_window_borders():
	var border_size = pixel
	var border_color = Colors.GREEN_DARKEST
	draw.draw_block(border_color, Vector2(0, 0), Vector2(Window.WIDTH, border_size * 6))
	draw.draw_block(border_color, Vector2(Window.WIDTH - border_size, 0), Window.SIZE)
	draw.draw_block(border_color, Vector2(0, Window.HEIGHT - border_size), Window.SIZE)
	draw.draw_block(border_color, Vector2(0, 0), Vector2(border_size, Window.HEIGHT))

func draw_background():
	draw.draw_block(Colors.GREEN_DARK, Vector2.ZERO, Window.SIZE)

func draw_food():
	draw.draw_block(Colors.GREEN_DARKEST, food_position, Vector2(pixel, pixel))
