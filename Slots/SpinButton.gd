extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
signal spin0Ready(nextSpin)
signal spin1Ready(nextSpin)
signal spin2Ready(nextSpin)
signal spin3Ready(nextSpin)
signal spin4Ready(nextSpin)
signal spinResultReady(nextRows)

signal setSpinning(isSpinning)


var numStopped=0
@export var totalReels = 5;
@export var enabled = true;
@export var totalCards = 12;
@export var wildCard = true;
@export var wildChance = 0.125;
@export var winRate = 0.1;
@export var totalRows = 5;
@export var wildIndex = 6;
@export var freeIndex = 7;
@export var freeCard = true;


var oddsSum = 546976.8708414147
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

func onReelStopped():
	numStopped+=1
	if(numStopped==totalReels):
		enabled=true
		spinResultReady.emit(currentRows)
		setSpinning.emit(false)
	
func choosePrize():
	var dice = randf()*oddsSum
	var os2 = 0	
	for payLine in payTable:
		os2+=payLine.odds
		if(os2>=dice):
			return payLine
	

func isWinner(row):
	for payLine in payTable:
		var lineMatch=true
		for i in range(0,row.size()):
			if(payLine.combo.substr(i,1)!="*" && payLine.combo.substr(i,1).hex_to_int()!=row[i] && row[i]!=wildIndex):
				lineMatch=false
				break
		if(lineMatch):
			return payLine
	return false

func genLoser():
	var row = [0,0,0,0,0];
	while true:
		for i in range(0,totalReels):
			row[i]=randi()%totalCards
		if(randf()<wildChance):
			var wildPos = randi()%totalReels
			row[wildPos]=wildIndex
		if(!isWinner(row)):
			return row
	return row

func genWinner():
	var payLine = choosePrize()
	var row=[]
	var newCard=0
	for i in range(0,payLine.combo.length()):
		if(payLine.combo.substr(i,1)=="*"):
			var shift=randi()%totalCards
			if(shift==0):
				shift=1
			newCard=(int(payLine.combo.substr(0,1))+shift)%totalCards
		else:
			newCard=int(payLine.combo.substr(i,1))
		row.append(newCard)
		
	if(randf()<wildChance):
		var mod = payLine.combo.find("*")
		if(mod==-1):
			mod=totalReels
		var wildPos = randi()%mod
		row[wildPos]=wildIndex
			
	return row

var currentSpins=[]
var currentRows=[]

func computeNextSpin():
	if(enabled):
		var nextSpins=[
			[0,1,2,3,4],
			[1,2,3,4,5],
			[2,3,4,5,0],
			[3,4,5,0,1],
			[4,5,0,1,2]
		]
		var rows=[]
		for row in range(0,totalRows):
			if(randf()<=winRate):
				rows.append(genWinner())
			else:
				rows.append(genLoser())
			for reel in range(0,rows[row].size()):
					nextSpins[reel][row]=rows[row][reel]
		
		spin0Ready.emit(nextSpins[0])
		spin1Ready.emit(nextSpins[1])
		spin2Ready.emit(nextSpins[2])
		spin3Ready.emit(nextSpins[3])
		spin4Ready.emit(nextSpins[4])
		
		currentRows=rows
		numStopped=0
		setSpinning.emit(true)
	enabled=false


