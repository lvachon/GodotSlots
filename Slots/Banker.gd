extends Label
@export var balance = 1000000
@export var denom = 100
@export var bet = 25
@export var wildIndex = 6
@export var winAnimTime = 3
@export var freeIndex = 7;

signal doSpin

signal showRow1Win(prize)
signal showRow2Win(prize)
signal showRow3Win(prize)
signal showRow4Win(prize)
signal showRow5Win(prize)
signal showWinnings(profit)
signal sendBet(bet)
signal stopAnims
signal signalFreeGames(games)
signal updateFreeGames(games)
signal doHistory(bet,profit,balance)

var spinning = false


var freeGames=0
var animsPlaying=false
var animProfit=0
var animTime=0
var winLineSignals = [showRow1Win,showRow2Win,showRow3Win,showRow4Win,showRow5Win]

var payTable = [
  {
	"combo": "000**",
	"prize": 3,
	"odds": 192450.08972987527
  },
  {
	"combo": "888**",
	"prize": 3,
	"odds": 192450.08972987527
  },
  {
	"combo": "111**",
	"prize": 10,
	"odds": 31622.776601683792
  },
  {
	"combo": "999**",
	"prize": 10,
	"odds": 31622.776601683792
  },
  {
	"combo": "222**",
	"prize": 15,
	"odds": 17213.259316477408
  },
  {
	"combo": "AAA**",
	"prize": 15,
	"odds": 17213.259316477408
  },
  {
	"combo": "0000*",
	"prize": 20,
	"odds": 11180.339887498949
  },
  {
	"combo": "8888*",
	"prize": 20,
	"odds": 11180.339887498949
  },
  {
	"combo": "777**",
	"prize": 25,
	"odds": 8000.000000000001
  },
  {
	"combo": "333**",
	"prize": 30,
	"odds": 6085.806194501846
  },
  {
	"combo": "BBB**",
	"prize": 30,
	"odds": 6085.806194501846
  },
  {
	"combo": "444**",
	"prize": 40,
	"odds": 3952.847075210474
  },
  {
	"combo": "1111*",
	"prize": 50,
	"odds": 2828.42712474619
  },
  {
	"combo": "555**",
	"prize": 50,
	"odds": 2828.42712474619
  },
  {
	"combo": "7777*",
	"prize": 50,
	"odds": 2828.42712474619
  },
  {
	"combo": "9999*",
	"prize": 50,
	"odds": 2828.42712474619
  },
  {
	"combo": "00000",
	"prize": 100,
	"odds": 1000.0000000000001
  },
  {
	"combo": "2222*",
	"prize": 100,
	"odds": 1000.0000000000001
  },
  {
	"combo": "88888",
	"prize": 100,
	"odds": 1000.0000000000001
  },
  {
	"combo": "AAAA*",
	"prize": 100,
	"odds": 1000.0000000000001
  },
  {
	"combo": "77777",
	"prize": 125,
	"odds": 715.5417527999327
  },
  {
	"combo": "11111",
	"prize": 250,
	"odds": 252.98221281347037
  },
  {
	"combo": "3333*",
	"prize": 250,
	"odds": 252.98221281347037
  },
  {
	"combo": "99999",
	"prize": 250,
	"odds": 252.98221281347037
  },
  {
	"combo": "BBBB*",
	"prize": 250,
	"odds": 252.98221281347037
  },
  {
	"combo": "22222",
	"prize": 300,
	"odds": 192.45008972987526
  },
  {
	"combo": "4444*",
	"prize": 300,
	"odds": 192.45008972987526
  },
  {
	"combo": "AAAAA",
	"prize": 300,
	"odds": 192.45008972987526
  },
  {
	"combo": "33333",
	"prize": 500,
	"odds": 89.44271909999159
  },
  {
	"combo": "5555*",
	"prize": 500,
	"odds": 89.44271909999159
  },
  {
	"combo": "BBBBB",
	"prize": 500,
	"odds": 89.44271909999159
  },
  {
	"combo": "44444",
	"prize": 1000,
	"odds": 31.622776601683796
  },
  {
	"combo": "55555",
	"prize": 10000,
	"odds": 1
  }
]

func setSpinning(isSpinning):
	spinning=isSpinning

func winAnimDone():
	animsPlaying=false
	text = "Cash: "+String.num(balance/100,2)

func increaseBet():
	if(bet<400 && !animsPlaying && !spinning && !freeGames):
		bet*=2
		sendBet.emit(bet)

func decreaseBet():
	if(bet>25 && !animsPlaying && !spinning && !freeGames):
		bet/=2
		sendBet.emit(bet)

func isWinner(row):
	for j in range(payTable.size()-1,-1,-1):
		var payLine=payTable[j]
		var lineMatch=true
		for i in range(0,row.size()):
			if(payLine.combo.substr(i,1).hex_to_int()!=row[i] && payLine.combo.substr(i,1)!="*" && row[i]!=wildIndex):
				lineMatch=false
				break
		if(lineMatch):
			return payLine
	return false

func onSpinResultReady(rows):
	var profit=0
	var newFreeGames=0
	for row in range(0,rows.size()):
		var winner = isWinner(rows[row])
		if(winner):
			if(int(winner.combo.substr(0,1))==freeIndex):
				newFreeGames+=winner.prize/5
				winLineSignals[row].emit(newFreeGames)
			else:
				profit+=winner.prize*bet/5*denom
				balance+=winner.prize*bet/5*denom
				winLineSignals[row].emit(winner.prize*bet/5*denom)
	
	
	
	showWinnings.emit(profit)
	
	if(newFreeGames>0):
		animsPlaying=true
		signalFreeGames.emit(newFreeGames)
		freeGames+=newFreeGames
	if(freeGames==0):
		doHistory.emit(bet,profit,balance)
	else:
		doHistory.emit(0,profit,balance)
	
	if(profit>0):
		animsPlaying=true
		animProfit=profit
		animTime=0
	

func onSpinPressed():
	if(animsPlaying):
		stopAnims.emit()
		text = "Cash: "+String.num(balance/100,2)
		animProfit=0
		return
	if(freeGames > 0):
		freeGames-=1
		doSpin.emit()
		updateFreeGames.emit(freeGames)
	if(balance>=denom*bet && !spinning):
		balance-=denom*bet
		text = "Cash: "+String.num(balance/100,2)
		doSpin.emit()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	doHistory.emit(0,0,balance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animTime+=delta
	if(animProfit>0 && animTime<winAnimTime):
		var newCash = int((balance-animProfit*(1-animTime/winAnimTime))/100)
		text = "Cash: "+String.num(newCash)
	else:
		text = "Cash: "+String.num(balance/100)
		animProfit=0
