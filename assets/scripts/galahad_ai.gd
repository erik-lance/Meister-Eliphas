extends Node2D

onready var game_manager = get_parent().get_parent()


var forced_y = null

var start_x = 1295
var end_x = 1320

var start_y = 426
var end_y = 500
var knight_scene = "res://assets/scenes/units/knight.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func harden():
	$Timer.wait_time = 10
	$ChanceTimer.wait_time = 18

func force_y(y):
	forced_y = y

func _on_Timer_timeout():
	var posx = randi() % (end_x - start_x) + 1
	var posy = randi() % (end_y - start_y) + 1
	
	var knight_inst = load(knight_scene).instance()
	
	game_manager.entity_node.add_child(knight_inst)
	
	
	knight_inst.position.x = posx + start_x
	if (forced_y != null):
		knight_inst.position.y = forced_y
	else: 
		knight_inst.position.y = posy + start_y

func _on_ChanceTimer_timeout():
	var posx = randi() % (end_x - start_x) + 1
	var posy = randi() % (end_y - start_y) + 1
	
	var knight_inst = load(knight_scene).instance()
	
	game_manager.entity_node.add_child(knight_inst)
	
	knight_inst.position.x = posx + start_x
	if (forced_y != null):
		knight_inst.position.y = forced_y
	else: 
		knight_inst.position.y = posy + start_y
