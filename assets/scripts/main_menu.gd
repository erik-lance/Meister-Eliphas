extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/MainButtons/Start.grab_focus()
	pass # Replace with function body.

onready var scene_manager = $SceneChanger
var cutscene_link = "res://assets/scenes/cutscene.tscn"
var battle_link = "res://assets/scenes/arena.tscn"

func _on_Start_pressed():
	var cur_scene = $Control
	var inst_scene = load(cutscene_link).instance()
	scene_manager.add_child(inst_scene)
	remove_child(cur_scene)

# This is called after cutscene so it's secure
func enter_battle():
	var cur_scene = scene_manager.get_child(0)
	var inst_scene = load(battle_link).instance()
	scene_manager.add_child(inst_scene)
	scene_manager.remove_child(cur_scene)

func _on_Quit_pressed():
	get_tree().quit();


func _on_Settings_button_up():
	get_tree().change_scene("res://assets/scenes/settings.tscn")
