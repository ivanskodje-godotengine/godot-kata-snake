class_name Draw
extends Node

var canvas

func _init(var canvas):
	self.canvas = canvas

func draw_block(var color, var start_corner, var end_corner):
	var colors = PoolColorArray([color])
	var points = PoolVector2Array()
	points.push_back(start_corner)
	points.push_back(start_corner + Vector2(end_corner.x, 0))
	points.push_back(start_corner + end_corner)
	points.push_back(start_corner + Vector2(0, end_corner.y))
	canvas.draw_polygon(points, colors)
