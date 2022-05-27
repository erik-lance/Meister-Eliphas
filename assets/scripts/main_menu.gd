extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MainButtons/Start.grab_focus()
	pass # Replace with function body.


func _on_Start_pressed():
	# get_tree().change_scene("res://assets/scenes")
	pass # Replace with function body.
	


func _on_Quit_pressed():
	get_tree().quit();
