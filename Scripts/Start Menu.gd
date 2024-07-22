extends TextureRect

var ftb = 0
var fade_finished = false
enum ACTIONS {NULL, PLAY, OPTIONS, CREDITS, QUIT}
var action = ACTIONS.NULL


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartMenu.set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("start")):
		$StartMenu.set_visible(true)
		$StartMenu/PlayButton.grab_focus()
	
	if($StartMenu/PlayButton.button_pressed && action == 0): action = 1
	if($StartMenu/OptionsButton.button_pressed && action == 0): action = 2
	if($StartMenu/CreditsButton.button_pressed && action == 0): action = 3
	if($StartMenu/QuitButton.button_pressed && action == 0): action = 4
	
	if(action != ACTIONS.NULL):
		ftb = delta
		$StartMenu/DummyButton.grab_focus()
	
	if(fade_finished):
		if(action == ACTIONS.PLAY):
			get_tree().change_scene_to_file("res://GD Scenes/Test Map.tscn")
		if(action == ACTIONS.OPTIONS):
			get_tree().reload_current_scene()
		if(action == ACTIONS.CREDITS):
			get_tree().reload_current_scene()
		if(action == ACTIONS.QUIT):
			get_tree().quit()
	
	fade_to_black(ftb)


var fade_level = 0
func fade_to_black(ftb):
	fade_level += ftb
	$FadeRect.set_color(Color(0, 0, 0, fade_level))
	if (fade_level >= 1): fade_finished = true
