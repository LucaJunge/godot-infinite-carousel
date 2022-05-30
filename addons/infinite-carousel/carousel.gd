tool
extends Container


export var starting_angle = PI / 2 # bottom of the circle
export var transition_time = 0.5
export var circle_height = 0.0
export var rotation_speed = 0.5
var child_count
var current_angle = starting_angle
var touch_start: Vector2
var currently_pressed: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	child_count = get_child_count()
	# for every child
	for i in child_count:
		#var child = get_child(i)
		set_on_circle(i, current_angle)
		current_angle += 2 * PI / child_count
		#fit_child_in_rect(child, )
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("pressed")
			currently_pressed = true
			touch_start = event.position
		else:
			currently_pressed = false
		
	if event is InputEventMouseMotion and currently_pressed:
		print("mouse motion")
		var difference_in_x = touch_start.x - event.position.x
		touch_start = event.position
		current_angle += difference_in_x * rotation_speed / 10
			
	pass

func set_on_circle(i, _angle):
	var angle = _angle + i * (2 * PI / child_count)
	var child = get_child(i)
	var center = Vector2(rect_size.x / 2, rect_size.y / 2)
	var sin_angle = sin(angle)
	var position = center + Vector2(cos(angle) * rect_size.x / 2, circle_height * sin_angle * rect_size.y / 2)
	child.rect_position = position
	
	# limit angle from 0 to 1
	sin_angle = (sin_angle + 1) / 2
	#print(sin_angle)
	#child.rect_scale = Vector2(cos_angle, cos_angle)
	if sin_angle <= 0.1:
		child.modulate = Color(1, 1, 1, 0)
		child.rect_scale = Vector2(0, 0)
	else:
		var expo_color = - exp(-20 * (sin_angle - 0.6)) + 1
		var expo_scale = - exp(-7 * (sin_angle - 0.45)) + 1
		child.modulate = Color(1, 1, 1, expo_color)
		child.rect_scale = Vector2(expo_scale, expo_scale)

	return sin_angle
	
	#print(position)

func _process(delta):
	for i in child_count:
		set_on_circle(i, current_angle)

func calculate_child_position(i):
	var angle_sign = -1 if i % 2 else 1
	var spacing = PI / child_count * (child_count - i - 2)
	var offset = starting_angle + angle_sign * spacing
	
	#if not child_count == i + 2:
	#pass
