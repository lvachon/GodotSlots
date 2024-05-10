extends Label

@export var winAnimTime = 3
@export var trillSound:AudioStreamPlayer

func showPrize(winProfit):
	text = "Prize:"+String.num(int(winProfit/100))
	startWinAnim(winProfit)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func stopAnim():
	text = "Prize: 0"
	profit=0
	if(trillSound):
		trillSound.stop()
		

var profit=0
var animTime=0
func startWinAnim(winProfit):
	profit=winProfit
	animTime=0
	if(trillSound && profit>0):
		trillSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(profit>0):
		if(profit-animTime*profit/winAnimTime>0):
			animTime+=delta
			text = "Prize: "+String.num(int(profit-animTime*profit/winAnimTime)/100)
		else:
			text = "Prize: 0"
			profit=0
