extends Node2D

onready var path = get_node("Path2D")
onready var dot = get_node("dotnormal")
onready var line = get_node("Line2D")
var linepath:Array = []
#gidilen yol t değişkenidir, 1 yolun sonu 0 ise başıdır
var t = 0.0

func _ready():
	pass

func _physics_process(delta):
	print(t)
	t = clamp(t,0,1)
	t += delta * 0.3
	line.points = linepath
	dot.position = _cubic_bezier(Vector2(200,500),Vector2(500,150),Vector2(700,150),Vector2(1000,500),t)
	linepath.append(dot.position)
	pass

func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var q2 = p2.linear_interpolate(p3, t)
	var r0 = q0.linear_interpolate(q1, t)
	var r1 = q1.linear_interpolate(q2, t)
	var s = r0.linear_interpolate(r1, t)
	return s

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
