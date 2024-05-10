extends Sprite2D
@export var switcher = false
@export var defaultY = 0
@export var altY = 8

var switchTime=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(switcher):
		switchTime+=delta
		if(int(switchTime/2)%2):
			frame_coords.y=altY
		else:
			frame_coords.y=defaultY
