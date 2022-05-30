extends Node2D

enum Owner {PLAYER, AI}
enum Status {SPECIAL, WALK, ATTACK, DEAD}

var unit_owner
var speed = 35
var cur_state = Status.WALK
var cur_enemy;

var hp = 45;
var dm = 20;

# Called when the node enters the scene tree for the first time.
func _ready():
	unit_owner = Owner.PLAYER

var target_list = []

func get_target():
	if (target_list.size() != 0): return target_list[0]
	else: return null

func defeated_target():
	target_list.pop_front()
	get_parent().switch_target()

# Adds to target list
func _on_Area2D_body_entered(body):
	target_list.append(body)
	
	if (target_list.size()==1): get_parent().switch_target()
	elif (get_parent().cur_enemy != null && get_parent().cur_enemy.name == "Static"):
		# If a new enemy appears while attacking castle, switch targets,
		# move castle as last priority in target list.
		target_list.append(target_list.pop_front())
		get_parent().switch_target()
