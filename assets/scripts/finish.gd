extends Node2D

func _ready():
	pass # Replace with function body.


func _on_Button_button_up():
	get_tree().change_scene("res://assets/scenes/main_menu.tscn")
