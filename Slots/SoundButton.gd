extends Button


var volume=2
signal setAllVolumes(vol)
var volumeSymbols = ["🔈","🔉","🔊"]
var volumeDbs = [-80,-9,-3]
func setVolume():
	volume=volume-1
	if(volume==-1):
		volume=2
	setAllVolumes.emit(volumeDbs[volume])
	text = volumeSymbols[volume]
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
