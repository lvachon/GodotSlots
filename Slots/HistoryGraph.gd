@tool
extends Node2D

var history = []
var nextBet = 0
@export var width = 128
@export var height = 640
@export var denom = 100
@export var startBal = 1000000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func onResult(bet,profit,balance):
	history.append([bet*denom,profit,balance])
	nextBet=0
	queue_redraw()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_rect(Rect2(0,0,width,height),Color(0,0,0,0.5),true)
	var maxBet = 1
	

	var maxBalanceD = 1
	
	var maxProfit = 1
	for row in history:
		if(abs(row[2]-startBal)>maxBalanceD):
			maxBalanceD=abs(row[2]-startBal)
		if(row[1]>maxProfit):
			maxProfit=row[1]
		if(row[0]>maxBet):
			maxBet=row[0]
	
	var deltaMax = max(maxBet,maxProfit)
	if(history.size()>1):
		for i in range(1,history.size()):
			var row=history[i]
			var y2=i*height/(history.size()-1)
			var x2=0.5*width*(row[2]-startBal)/(maxBalanceD)
			var y1=(i-1)*height/(history.size()-1)
			var x1=0.5*width*(history[i-1][2]-startBal)/(maxBalanceD)
			draw_line(Vector2(width/2+x1,y1),Vector2(width/2+x2,y2),Color(0,196,0),2,true)
		for i in range(0,history.size()):
			var row=history[i]
			var y2=i*height/(history.size()-1)
			var x2=0.5*width*(row[1])/(deltaMax)
			draw_line(Vector2(width/2,y2),Vector2(width/2+x2,y2),Color(0,0,196),1,true)
		for i in range(0,history.size()):
			var row=history[i]
			var y2=i*height/(history.size()-1)
			var x2=0.5*width*(row[0])/(deltaMax)
			draw_line(Vector2(width/2,y2),Vector2(width/2-x2,y2),Color(196,0,0),1,true)
	draw_line(Vector2(width/2,0),Vector2(width/2,height),Color(196,196,196))
