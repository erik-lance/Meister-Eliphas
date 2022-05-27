# This will handle the controls for the whole arena
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main_camera = $Camera2D;
var speed = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("camera_left")): main_camera.transform.origin.x -= 1 * speed;
	elif (Input.is_action_pressed("camera_right")): main_camera.transform.origin.x += 1 * speed;
	pass
