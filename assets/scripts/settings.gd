extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)


func _on_Button_button_up():
	get_tree().change_scene("res://assets/scenes/main_menu.tscn")
