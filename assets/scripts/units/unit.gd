extends Node2D

enum Owner {PLAYER, AI}
enum Status {WALK, ATTACK, DEAD}

onready var unit_data = $UnitData
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var hitbox = $KinematicBody2D/Hitbox
onready var hurtbox = $Area2D/Hurtbox
onready var hp_bar = $HealthBar

var speed = 0.5
var dir
var unit_owner
var cur_state = Status.WALK
var cur_enemy

var hp
var dm

# Called when the node enters the scene tree for the first time.
func _ready():
	use_data()
	
	unit_owner = unit_data.unit_owner
	if (unit_owner == Owner.PLAYER): dir = 1
	else: dir = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (cur_state != Status.DEAD):
		if (cur_state == Status.WALK):
			position.x += dir*speed;
			anim_player.play("walk")
		elif(cur_state == Status.ATTACK):
			anim_player.play("attack")
	else:
		pass

func set_owner_player(n=true):
	if (n):
		unit_owner = Owner.PLAYER
		dir = 1
	else:
		unit_owner = Owner.AI
		dir = -1

func use_data():
	hp = unit_data.hp
	dm = unit_data.dm
	speed = unit_data.speed
	
	hp_bar.max_value = hp
	hp_bar.value = hp

func update_hp_bar():
	
	hp_bar.value = hp
	if (hp > hp_bar.max_value*.75): hp_bar.theme = load("res://assets/themes/health_bar_good.tres")
	elif (hp > hp_bar.max_value*.50): hp_bar.theme = load("res://assets/themes/health_bar_medium.tres")
	elif (hp > hp_bar.max_value*.25): hp_bar.theme = load("res://assets/themes/health_bar_bad.tres")
	else: hp_bar.theme = load("res://assets/themes/health_bar_dead.tres")

func switch_target():
	cur_enemy = unit_data.get_target()
	if cur_enemy != null: cur_state = Status.ATTACK
	else: cur_state = Status.WALK

# This is called from the animation player
func inflict_damage():
	var defeated = false
	defeated = cur_enemy.get_parent().take_damage(dm)
	# Sends a signal to data to remove from target list
	if(defeated): unit_data.defeated_target()

func take_damage(d):
	if (hp_bar.visible == false): hp_bar.visible = true
	hp -= d;
	print(self.name+" "+str(hp))
	update_hp_bar()
	if (hp <= 0):
		cur_state = Status.DEAD;
		if (unit_owner == Owner.PLAYER):
			$KinematicBody2D.set_collision_layer_bit(1,false)
		else:
			$KinematicBody2D.set_collision_layer_bit(2,false)
		anim_player.play("dead")
		return true
	return false

func remove_unit():
	self.queue_free()
