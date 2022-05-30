# This will handle the controls for the whole arena
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main_camera = $Camera2D
onready var entity_node = $Entities
onready var main_ui = $Control

onready var eliphas = $BaseMaps/Eliphas

onready var player_hp = $Control/Control/Player/ProgressBar
onready var enemy_hp = $Control/Control/Enemy/ProgressBar

var speed = 500

onready var player_base = $Map/PlayerBase
onready var enemy_base = $Map/EnemyBase

onready var game_ui = $Control

var winner = null
var is_game_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player_base.game_manager = self
	player_base.base_owner = 0
	enemy_base.game_manager = self
	enemy_base.base_owner = 1
	
	game_ui.game_manager = self
	
	enemy_base.gal_ai = $BaseMaps/GalahadAI
	

func update_health_player(h, n):
	player_hp.value = h
	match(n):
		0: player_hp.theme = load("res://assets/themes/health_bar_good.tres")
		1: player_hp.theme = load("res://assets/themes/health_bar_medium.tres")
		2: player_hp.theme = load("res://assets/themes/health_bar_bad.tres")
		3: player_hp.theme = load("res://assets/themes/health_bar_dead.tres")

func update_health_enemy(h, n):
	enemy_hp.value = h
	match(n):
		0: enemy_hp.theme = load("res://assets/themes/health_bar_good.tres")
		1: enemy_hp.theme = load("res://assets/themes/health_bar_medium.tres")
		2: enemy_hp.theme = load("res://assets/themes/health_bar_bad.tres")
		3: enemy_hp.theme = load("res://assets/themes/health_bar_dead.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("speed_up_camera")):
		speed = 1500
	else: speed = 500
	
	if (Input.is_action_pressed("camera_left") && main_camera.position.x > -32): 
		main_camera.transform.origin.x -= 1 * speed * delta;
		if (game_ui.start_message.visible): game_ui.start_message.visible = false
	elif (Input.is_action_pressed("camera_right") && main_camera.position.x < 1276):
		main_camera.transform.origin.x += 1 * speed * delta;
		if (game_ui.start_message.visible): game_ui.start_message.visible = false
	elif (Input.is_action_just_released("camera_home")):
		main_camera.transform.origin.x = 178
	elif (Input.is_action_just_released("camera_enemy")):
		main_camera.transform.origin.x = 1124


func _on_Eliphas_animation_finished():
	eliphas.play("default")
	if (player_base.cur_state == 1):
		player_base.inflict_damage()

# True is Enemy Base, False is Player base
func base_dead(b):
	if (winner == null):
		if (b == true): winner = true
		else : winner = false
		is_game_done = true
		$Finish.start()

func _on_Finish_timeout():
	if (winner): get_tree().change_scene("res://assets/scenes/finish_win.tscn")
	else: get_tree().change_scene("res://assets/scenes/finish_lose.tscn")
