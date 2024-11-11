extends Node

var clickpos 
var cellpos
var celltype
var globalpos 

var nobuild = [] #positions where u can't build

var buildlist = [
	
	"coal"  , Vector2i(6,2),
	"warehouse" , Vector2i(1,0)
	
				]

var coal = 0
var gematit = 0
var iron = 0
var galenit = 0
var lead = 0
var chemicals = 0
var plastic = 0
