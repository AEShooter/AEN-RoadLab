extends Node2D

onready var dot_example = preload("res://nodes/dot_example.tscn")

var mousepos
var parent = self
var tree
var linepath:Array = []
onready var line
onready var start_dot
onready var end_dot
onready var parent_line = get_node("lines")
onready var parent_start_dot = get_node("start_dots")
onready var parent_end_dot = get_node("end_dots")
onready var debug_text = get_node("debug_text")

var SELECTED_LINE
var SELECTED_LINE_COUNT = 0
var LINE_COUNT_IN_PARENT = 0
var SELECTED_START_DOT_COUNT = 0
var START_DOT_COUNT_IN_PARENT = 0
var SELECTED_END_DOT_COUNT = 0
var END_DOT_COUNT_IN_PARENT = 0

func _ready():
	yield(get_tree(), "idle_frame")
	parent_things()

func _physics_process(delta):
	debug_text.text = "LINE COUNT: "+ str(linepath.size())
	pass

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
		pass
	if event is InputEventMouseButton:
		if line != null and start_dot != null:
			if event.button_index == BUTTON_LEFT && event.pressed: #EKLEMEK
				mousepos = get_global_mouse_position()
				linepath.append(mousepos)
				line.points = linepath
				if linepath.size() == 1:
					start_dot.position = linepath.front()
					start_dot.visible = true
				elif linepath.size() >= 2:
					end_dot.position = linepath.back()
					end_dot.visible = true
				print("çizgi uzunluğu: ",linepath.size(),"\nçizgi ilk birimi: ",linepath.front(),"\nçizgi son birimi: ",linepath.back())
				
			if event.button_index == BUTTON_RIGHT && event.pressed: #ÇIKARTMAK
				mousepos = get_global_mouse_position()
				if linepath.size() != 0:
					start_dot.visible = true
					linepath.resize(linepath.size() - 1)
				if linepath.size() >= 2:
					end_dot.position = linepath.back()
					end_dot.visible = true
				else:
					end_dot.visible = false
				line.points = linepath
				if linepath.size() == 0:
					start_dot.visible = false
					end_dot.visible = false
				print("çizgi uzunluğu: ",linepath.size(),"\nçizgi ilk birimi: ",linepath.front())
			

func parent_things():
	tree = get_tree()
	line_creator()
	print("parent: ",parent,", \nchild count: ",self.get_child_count(),", \nchild's child count: ",LINE_COUNT_IN_PARENT,", \nline name: ",line,", \nline and start_dot node: ",line," , ",start_dot,", \nparent line: ",parent_line,", \nselected line count: ",SELECTED_LINE_COUNT)
	
func line_creator():
	var new_start_dot = dot_example.instance()
	var new_end_dot = dot_example.instance()
	var new_line = Line2D.new()
	
	#LINE kurulumu
	new_line.joint_mode = Line2D.LINE_JOINT_ROUND
	new_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	new_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	new_line.width = 3
	#START_DOT kurulumu
	new_start_dot.modulate = Color(0.042268, 0.524485, 0.920898)
	new_start_dot.scale = Vector2(5,5)
	new_start_dot.visible = false
	new_start_dot.z_index = 1
	#END_DOT kurulumu
	new_end_dot.modulate = Color(0.827451, 0.058824, 0.058824)
	new_end_dot.scale = Vector2(5,5)
	new_end_dot.visible = false
	new_end_dot.z_index = 1
	
	#BURADAN SONRA CHILD OLAYLARI BAŞLIYOR
	parent_start_dot.add_child(new_start_dot)
	parent_line.add_child(new_line)
	parent_end_dot.add_child(new_end_dot)
	line = parent_line.get_child(0)
	start_dot = parent_start_dot.get_child(0)
	end_dot = parent_end_dot.get_child(0)
	LINE_COUNT_IN_PARENT = parent_line.get_child_count()
	START_DOT_COUNT_IN_PARENT = parent_start_dot.get_child_count()
	END_DOT_COUNT_IN_PARENT = parent_end_dot.get_child_count()

func line_chooser(child_line:int,child_start_dot:int,child_end_dot:int):
	line = parent_line.get_child(child_line)
	start_dot = parent_start_dot.get_child(child_start_dot)
	end_dot = parent_end_dot.get_child(child_end_dot)
	pass

