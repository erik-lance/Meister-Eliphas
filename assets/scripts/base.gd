# This script handles everything related to the base
extends Node2D

enum Owner {PLAYER, AI}
enum Status {IDLE, ATTACK, DEAD}

var cur_state = Status.IDLE
var gal_ai

var game_manager
var base_owner
var cur_enemy

var max_hp = 1500
var hp = max_hp

var dm = 20

var target_list = []

onready var audio_player = $AudioStreamPlayer2D
var sound_hit = preload("res://assets/audio/sfx/light_hit.wav")
var sound_dead = preload("res://assets/audio/sfx/hit_hard.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (target_list.size() > 0):
		
		if (base_owner == Owner.AI):
			if (target_list[0].get_parent() != null):
				gal_ai.force_y(target_list[0].get_parent().position.y)	
				# Checks if current target is dead
				if (target_list[0].get_parent().cur_state == 3):
					target_list.pop_front()
					gal_ai.force_y(null)
			else:
				gal_ai.force_y(null)
		elif (base_owner == Owner.PLAYER && (cur_state != Status.DEAD)):
			if (cur_state == Status.ATTACK):
				game_manager.eliphas.play("point")

func get_target():
	if (target_list.size() != 0): return target_list[0]
	else: return null

func switch_target():
	cur_enemy = get_target()
	if cur_enemy != null: cur_state = Status.ATTACK
	else: cur_state = Status.IDLE

func defeated_target():
	target_list.pop_front()
	switch_target()

func inflict_damage():
	var defeated = false
	defeated = cur_enemy.get_parent().take_damage(dm)
	# Sends a signal to data to remove from target list
	if(defeated): defeated_target()

func take_damage(d):
	hp -= d;
	var hp_state
	
	if (hp > max_hp*.75): hp_state = 0
	elif (hp > max_hp*.50): hp_state = 1
	elif (hp > max_hp*.25): hp_state = 2
	else: hp_state = 3
	
	if (base_owner == Owner.AI):
		game_manager.update_health_enemy(hp, hp_state)
		if (hp < max_hp *.50): gal_ai.harden()
	else:
		game_manager.update_health_player(hp, hp_state)
		if (hp < max_hp *.50): game_manager.main_ui.ease_game()
	
	
	
	if (hp <= 0):
		if (base_owner == Owner.PLAYER): game_manager.base_dead(false)
		else: game_manager.base_dead(true)
		
		audio_player.stream = sound_dead
		audio_player.play()
		cur_state = Status.DEAD;
		return true
	else:
		audio_player.stream = sound_hit
		audio_player.play()
		return false

# Only  for enemy base AI
func _on_Area2D_body_entered(body):
	target_list.append(body)
	if (base_owner == Owner.PLAYER && target_list.size()==1): switch_target()
