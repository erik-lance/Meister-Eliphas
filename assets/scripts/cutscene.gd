extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var text = [
	"Click anywhere to advance text",
	"In Eliphas' quest for power, he decided to take camp",
	"at the abandoned wooden fort that was previously used in the last war.",
	"Being a wanted man, Lt. Galahad was lucky to find Eliphas alone.",
	"'Surrender yourself to the law!' Galahad exclaimed against Eliphas",
	"'You dare challenge the power of the master of the spatial arts?'",
	"As Eliphas opens several portals at once, Galahad was shocked at what he saw.",
	"Orcs and imps from the last war, some familiar, some never seen before.",
	"'You shall be my test subject - with my power to bring the dead from the afterlife!'",
	"Click to begin."
]

onready var label = $Label
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_released("click")):
		if (index < text.size()):
			label.text = text[index]
		else: get_parent().get_parent().enter_battle()
		index+= 1


func _on_Button_pressed():
	get_parent().get_parent().enter_battle()
