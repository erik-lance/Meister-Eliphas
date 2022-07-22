extends Node2D

onready var master_s = $CanvasLayer/VBoxContainer/master_slider
onready var music_s = $CanvasLayer/VBoxContainer/music_slider
onready var sfx_s = $CanvasLayer/VBoxContainer/sfx_slider

# Called when the node enters the scene tree for the first time.
func _ready():
	master_s.value = AudioServer.get_bus_volume_db(0)
	music_s.value = AudioServer.get_bus_volume_db(1)
	sfx_s.value = AudioServer.get_bus_volume_db(2)

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
