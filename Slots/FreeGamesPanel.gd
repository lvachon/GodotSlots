extends Panel

var animTime=0
@export var showTime=3
signal animDone

func onSignalFreeGames(games):
	visible=true
	animTime=0
	get_child(1).text = String.num(games)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animTime+=delta
	if(animTime>showTime):
		if(visible):
			animDone.emit()
		visible=false
		
