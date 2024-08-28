extends Window

var file = "res://Docs/Licenses.md"

var content: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/MarkdownLabel.display_file(file)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_joy_button_pressed(0, JOY_BUTTON_B)):
		hide()


func _on_close_requested():
	hide()
