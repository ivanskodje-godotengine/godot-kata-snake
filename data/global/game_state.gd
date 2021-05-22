extends Node

var food_position = []

func add_food(var pos):
	food_position.append(pos)

func remove_food(var pos):
	var index = food_position.find(pos)
	food_position.remove(index)

func get_food() -> Array:
	return food_position

func is_food(var pos):
	return food_position.has(pos)
