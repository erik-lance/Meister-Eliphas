extends Node2D

enum Owner {PLAYER, AI}
enum Status {WALK, ATTACK, DEAD}

var unit_owner
var speed = 0.5
var cur_state = Status.WALK
var cur_enemy;

var hp = 70;
var dm = 35;

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
