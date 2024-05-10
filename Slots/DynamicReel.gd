@tool
extends CanvasGroup


var sprites: Array

@export var cardFile = "res://allcards-0.png"
@export var cardCount = 12
@export var cardFrames = 30
@export var playfield: Sprite2D
@export var reelsize = 5
@export var spriteScale = Vector2(1,1.05)
@export var tickSound: AudioStreamPlayer
@export var tickOffset = 0
var parentRect: Rect2
var card_height
var cardImage

func initSprite(card,pos):
	var spr = Sprite2D.new()
	spr.texture = cardImage
	spr.hframes=30
	spr.vframes=12
	spr.frame_coords.y=card
	spr.translate(Vector2(0,pos*card_height))
	spr.name = "sprite_%s" % pos
	sprites.append(spr)
	add_child(spr)


func _init():
	cardImage = load(cardFile)
	var testSprite = Sprite2D.new()
	testSprite.texture = cardImage
	testSprite.hframes=30
	testSprite.vframes=12
	testSprite.frame_coords.y=0
	card_height = testSprite.get_rect().size.y
	for i in range(0,reelsize*3):
		initSprite(randi()%cardCount,i)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	parentRect = playfield.get_rect()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
@export var startVel=10.0
@export var spinTime=0.5
var vel=0
var curSpinTime=0
var scramble=false
var spinning=false
@export var stopPosition = -2
var reelImages
var animateRows = [false,false,false,false,false]
var animTime = 0
signal spinDone

func showWin0(_prize):
	animateRows[0]=true
	animTime=0
func showWin1(_prize):
	animateRows[1]=true
	animTime=0
func showWin2(_prize):
	animateRows[2]=true
	animTime=0
func showWin3(_prize):
	animateRows[3]=true
	animTime=0
func showWin4(_prize):
	animateRows[4]=true
	animTime=0
	
func trySpin(nextReelImages):
	if(!spinning):
		spin(nextReelImages)

func spin(nextReelImages):
	spinning=true
	scramble=true
	reelImages=nextReelImages
	for i in range(nextReelImages.size(),sprites.size()):
		sprites[i].frame_coords.y=randi()%cardCount
	vel=startVel
	curSpinTime=0

func _process(delta):
	curSpinTime+=delta
	if(curSpinTime>spinTime && sprites[0].position.y < stopPosition*card_height ):
		vel=min(vel,25*(stopPosition*card_height-sprites[0].position.y)/card_height*1.0)
	if(vel<1/card_height):
		if(spinning):
			spinDone.emit()
			tickSound.play()
		spinning=false
	#if(vel > startVel/2 && abs(int(sprites[0].position.y)) % int(card_height*4) <= vel*delta*1.5):
		
	for i in range(0,sprites.size()):
		var spr = sprites[i]
		spr.translate(Vector2(0,vel*card_height*delta))
		if(spr.position.y > parentRect.end.y+card_height*2):
			spr.translate(Vector2(0,card_height*-sprites.size()))
		
	if(scramble && sprites[0].position.y<parentRect.position.y-card_height):
		for i in range(0,reelImages.size()):
			sprites[i].frame_coords.y=reelImages[i]
		scramble=false
	
	var anims=false
	for i in range(0,animateRows.size()):
		if(animTime>1):
			animateRows[i]=false
		else:
			if(animateRows[i]):
				anims=true
				sprites[i].frame_coords.x=int(animTime*cardFrames)%cardFrames
	if(anims):
		animTime+=delta



