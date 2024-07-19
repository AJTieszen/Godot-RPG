extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var frame_label = $Label
	
	var frame_rate = int(1 / delta)
	var frame_time_ms = delta * 1000
	
	var line_1 = "%d FPS" % frame_rate
	var line_2 = "%0.2f ms" % frame_time_ms
	frame_label.text = line_1 + "\n" + line_2
