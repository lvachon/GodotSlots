extends Line2D

signal animDone

@export var flashSpeed = 2
@export var winChime: AudioStreamPlayer
var flashStart = 10

func showPrize(prize):
	get_child(0).text = String.num(prize/100,2)
	startFlashing()

func startFlashing():
	flashStart=0

func stopFlashing():
	flashStart=5
	animDone.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	#get_child(0).hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	flashStart+=delta
	if(int(flashStart*flashSpeed)%2>0 && flashStart<3):
		if(winChime && !visible):
			winChime.play()
		show()
		
	else:
		hide()
		if(flashStart>3 && flashStart<4):
			animDone.emit()
	
