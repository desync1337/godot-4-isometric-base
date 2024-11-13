extends TileMapLayer

@onready var forest = preload("res://scenes/gen_forest.tscn")
@onready var lightforest = preload("res://scenes/gen_lightforest.tscn")

@export var noise_texture : FastNoiseLite
var rng = RandomNumberGenerator.new()

var nobuild = [] #positions where u can't builds

func _ready() -> void:
	generate_island()

func clear_island():
	for e in get_children():
		if e.is_in_group("gen"):
			e.queue_free()
	clear()
	nobuild.clear()
	
func generate_island():
	rng.randomize()
	
	clear_island()
	var randomsize = rng.randf_range(4,10)

	for x in range(16):
		for y in range(32):
			var distance = Vector2i(x,y).distance_to(Vector2i(8,16))
			var percentage = rng.randf_range(0.0,1.0)
			
			if distance < randomsize - rng.randf_range(0.1,2):
				set_cell(Vector2i(x - 8,y - 16),0,Vector2i(1,0))
				
				if percentage < 0.05:# ::COALCELL::
					set_cell(Vector2i(x - 8,y - 16),0,Vector2i(6,2))
					#print("returned")
					continue
				
				if percentage < 0.1:# ::FOREST::
					var genforest = forest.instantiate()
					genforest.position = map_to_local(Vector2i(x - 8,y - 16))
					add_child(genforest)
					
					var cellsaround = get_surrounding_cells(Vector2i(x - 8,y - 16))
					#print(cellsaround)
					for e in cellsaround:
						if nobuild.has(map_to_local(e)): 
							print("FUCK YOU")
							#return
						#G.nobuild.find(map_to_local(e * 0.1))
						#print(nobuild.find(map_to_local(e * 0.1)))
						var genlightforest = lightforest.instantiate()
						genlightforest.position = map_to_local(e)
						add_child(genlightforest)
						set_cell(e ,0,Vector2i(1,1))
						
					continue
				
				
