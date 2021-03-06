extends Node2D

enum Mode {IDLE, SELECTED_UNIT, SELECTED_ABILITY}
var game_manager

onready var btn_container = $Control/HBoxContainer
onready var select_label = $Control/SelectNote
onready var dump = $Control/Dump

onready var start_message = $Control/Start
onready var income_timer = $Timer

var cur_mode = Mode.IDLE
var cur_select = null

var universal_timer = 10
var coins = 500
var coin_increment = 70
var slot_prices = [150, 40]
var slot_avail = [true, true]

var select_sprite = null

var orc_link = "res://assets/scenes/units/orc_spawn.tscn"
var orc_scene = "res://assets/scenes/units/orc.tscn"

var imp_link = "res://assets/scenes/units/imp_spawn.tscn"
var imp_scene = "res://assets/scenes/units/imp.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (Input.is_action_just_released("open_1")):
		slot_n_select(0)
	elif ( Input.is_action_just_released("open_2")):
		slot_n_select(1)
	
	if (Input.is_action_pressed("deselect") && cur_mode != Mode.IDLE):
		reset_buttons()
	
	# Follow cursor instantiate
	if (cur_select != null):
		select_sprite.position = get_viewport().get_mouse_position()
		
		if (check_valid_spawn()):
			select_sprite.modulate = Color("73ffffff")
			if (Input.is_action_pressed("click") && (coins-slot_prices[cur_select]>= 0) && slot_avail[cur_select]):
				match(cur_select):
					0: load_slot_1()
					1: load_slot_2()
					_: print("Null slot found?")
				
				game_manager.eliphas.play("point")
				$Control/WarningNote.visible = false
				$Control/Player/CoinPanel/Label.text = "@ "+str(coins)
			else:
				pass
#				print("Coin Expense: "+str(coins-slot_prices[cur_select]))
#				print("Avail: "+str(slot_avail[cur_select]))
		else:
			select_sprite.modulate = Color("735e0000")
			if (Input.is_action_pressed("click")):
				$Control/WarningNote.visible = true
		

func check_valid_spawn():
	var x = get_global_mouse_position().x
	var y = get_global_mouse_position().y
	
	if ((x > -64 && x < 256) && (y > 426 && y < 500)):
		return true
	elif (cur_select == 1 && (x > -64 && x < 256) && (y > 426 && y < 516)):
		return true
	else: return false

func open_slot_1():
	select_sprite = load(orc_link).instance()
	dump.add_child(select_sprite)

func open_slot_2():
	select_sprite = load(imp_link).instance()
	dump.add_child(select_sprite)

func load_slot_1():
	coins -= 150
	
	var orc1 = load(orc_scene).instance()
	var orc2 = load(orc_scene).instance()
	
	game_manager.entity_node.add_child(orc1)
	game_manager.entity_node.add_child(orc2)
	orc1.position = get_global_mouse_position()
	orc2.position = get_global_mouse_position()
	
	orc1.cur_state = 0
	orc2.cur_state = 0
	orc1.anim_player.play("spawn")
	orc2.anim_player.play("spawn")
	
	orc2.position.y += 9
	$Control/HBoxContainer/Slot_1/TextureRect.modulate = Color("747474")
	$Control/HBoxContainer/Slot_1/slot1_timer.start()

	slot_avail[cur_select] = false
	reset_buttons()

func load_slot_2():
	coins -= 40
	var imp = load(imp_scene).instance()
	
	game_manager.entity_node.add_child(imp)
	imp.position = get_global_mouse_position()
	imp.cur_state = 0
	imp.anim_player.play("spawn")
	
	$Control/HBoxContainer/Slot_2/TextureRect.modulate = Color("747474")
	$Control/HBoxContainer/Slot_2/slot2_timer.start()
	
	slot_avail[cur_select] = false
	reset_buttons()

func reset_buttons():
	cur_mode = Mode.IDLE
	
	cur_select = null
	select_label.visible = false
	$Control/HBoxContainer/Slot_1.pressed = false
	$Control/HBoxContainer/Slot_2.pressed = false
	for i in dump.get_children():
		i.queue_free()

func slot_n_select(n):
	if (cur_select != n):
		reset_buttons()
		cur_mode = Mode.SELECTED_UNIT
		match(n):
			0: open_slot_1()
			1: open_slot_2()
		cur_select = n
		select_label.visible = true
	else: reset_buttons()

func ease_game():
	universal_timer = 7
	coin_increment = 100
	$Control/HBoxContainer/Slot_1/slot1_timer.wait_time = universal_timer
	$Control/HBoxContainer/Slot_2/slot2_timer.wait_time = universal_timer
	income_timer.wait_time = universal_timer
	

func _on_Slot_1_pressed(): slot_n_select(0)
func _on_Slot_2_pressed(): slot_n_select(1)

func _on_Timer_timeout():
	coins += coin_increment
	$Control/Player/CoinPanel/Label.text = "@ "+str(coins)

func _on_slot1_timer_timeout():
	$Control/HBoxContainer/Slot_1/TextureRect.modulate = Color("ffffff")
	slot_avail[0] = true

func _on_slot2_timer_timeout():
	$Control/HBoxContainer/Slot_2/TextureRect.modulate = Color("ffffff")
	slot_avail[1] = true
