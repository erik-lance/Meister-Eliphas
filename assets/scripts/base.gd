# This script handles everything related to the base
extends Node2D

enum Owner {PLAYER, AI}
enum Status {IDLE, ATTACK, DEAD}

var cur_state = Status.IDLE

var game_manager
var base_owner
var cur_enemy

var hp = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(d):
	hp -= d;
	var hp_state
	
	if (hp > 1000*.75): hp_state = 0
	elif (hp > 1000*.50): hp_state = 1
	elif (hp > 1000*.25): hp_state = 2
	else: hp_state = 3
	
	if (base_owner == Owner.AI):
		game_manager.update_health_enemy(hp, hp_state)
	else:
		game_manager.update_health_player(hp, hp_state)
	
	
	if (hp <= 0):
		cur_state = Status.DEAD;
		return true
	return false
