extends Node2D

enum Owner {PLAYER, AI}
enum Status {WALK, ATTACK, DEAD}

onready var unit_data = $UnitData
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var hitbox = $KinematicBody2D/Hitbox
onready var hurtbox = $Area2D/Hurtbox

var speed = 0.5
var dir = 1
var unit_owner
var cur_state = Status.WALK
var cur_enemy

var hp
var dm

# Called when the node enters the scene tree for the first time.
func _ready():
	use_data()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (cur_state != Status.DEAD):
		if (cur_state == Status.WALK):
			position.x += dir*speed;
			anim_player.play("walk")
		elif(cur_state == Status.ATTACK):
			anim_player.play("attack")

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
	hp -= d;
	if (hp <= 0):
		cur_state = Status.DEAD;
