extends TextureRect

var startMenuEnabled = false
var ftb = 0
var fade_finished = false
enum ACTIONS {NULL, PLAY, OPTIONS, CREDITS, LICENSE, README, QUIT}
var action = ACTIONS.NULL

var next_scene = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartMenu.set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Display start menu
	if(Input.is_anything_pressed() && !startMenuEnabled):
		$StartMenu.set_visible(true)
		$StartMenu/PlayButton.grab_focus()
	
	# Handle input
	if($StartMenu/PlayButton.button_pressed):
		action = ACTIONS.PLAY
		$AudioStreamPlayer2D.play()
	if($StartMenu/OptionsButton.button_pressed):
		action = ACTIONS.OPTIONS
		$AudioStreamPlayer2D.play()
	if($StartMenu/CreditsButton.button_pressed):
		action = ACTIONS.CREDITS
		$AudioStreamPlayer2D.play()
	if($StartMenu/LicenseButton.button_pressed):
		action = ACTIONS.LICENSE
		$AudioStreamPlayer2D.play()
	if($StartMenu/ReadMeButton.button_pressed):
		action = ACTIONS.README
		$AudioStreamPlayer2D.play()
	if($StartMenu/QuitButton.button_pressed):
		action = ACTIONS.QUIT
		$AudioStreamPlayer2D.play()
	if(startMenuEnabled && Input.is_action_just_pressed("start")):
		action = ACTIONS.PLAY
		$AudioStreamPlayer2D.play()
	
	# Start fade to black, preload scenes
	if(action != ACTIONS.NULL):
		$StartMenu/DummyButton.grab_focus()
		if(action == ACTIONS.PLAY): next_scene = preload("res://GD Scenes/Test Map.tscn")
		if(action == ACTIONS.LICENSE):
			$LicenseWindow.show()
			action = ACTIONS.NULL
		if(action == ACTIONS.README):
			$ReadMeWindow.show()
			action = ACTIONS.NULL
		else: ftb = delta
		fade_to_black(ftb)
	
	# Perform selected action
	if(fade_finished):
		if(action == ACTIONS.PLAY): get_tree().change_scene_to_packed(next_scene)
		if(action == ACTIONS.OPTIONS): get_tree().reload_current_scene()
		if(action == ACTIONS.CREDITS): get_tree().reload_current_scene()
		if(action == ACTIONS.QUIT): get_tree().quit()
	
	# Activate start menu after setting visible
	if($StartMenu.is_visible_in_tree()):
		startMenuEnabled = true


var fade_level = 0
func fade_to_black(f):
	fade_level += f
	$FadeRect.set_color(Color(0, 0, 0, fade_level))
	if (fade_level >= 1): fade_finished = true


func _on_license_window_visibility_changed():
	if($LicenseWindow/MarginContainer.is_visible_in_tree()): $StartMenu/LicenseButton.grab_focus()
