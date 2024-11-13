extends Camera2D
#cell types:
	#[6,2] coal
	
	#[0,0]
	#[1,0] grass
	
	#[2,0] sand

var mode = "view" # [build , view]
@onready var qmenu = get_parent().get_node("qmenu")
@onready var cursor = get_parent().get_node("3dcursor")
@onready var world = get_parent()

@onready var warehouse = preload("res://scenes/warehouse.tscn")
@onready var coalfac = preload("res://scenes/coalfactory.tscn")

func _input(event: InputEvent) -> void:
	
	$debugtext.text = str(
		"celltype: " , G.celltype, 
		"\ncellglobalpos: ", G.globalpos,
		"\nmode: ", mode,
		"\nselectedbuild: ", G.selectbuild,
		"\nmoney: ", G.money,
		"\ncoal: ",G.coal,
		"\ngematit: ",G.gematit,
		"\niron: " ,G.iron,
		"\nlead: ")
	
	if Input.is_action_just_pressed("+scroll") and zoom.x < 4.3:
		zoom.x += 0.5
		zoom.y += 0.5
	if Input.is_action_just_pressed("-scroll") and zoom.x > 1.75:
		zoom.x -= 0.5
		zoom.y -= 0.5
	
	if Input.is_action_just_pressed("+b"):
		mode = "build"
	if Input.is_action_just_pressed("+v"):
		mode = "view"
	if Input.is_action_just_pressed("+x"):
		mode = "delete"
	
	if Input.is_action_just_pressed("+q"):
		qmenu.visible = true
		qmenu.position = Vector2(G.clickpos.x, G.clickpos.y + 117)
		
	
	G.clickpos = get_global_mouse_position()
	G.cellpos = world.local_to_map(Vector2(G.clickpos.x,G.clickpos.y))
	G.celltype = world.get_cell_atlas_coords(G.cellpos)
	G.globalpos = world.map_to_local(G.cellpos)

	if mode == "view":
		cursor.visible = false
		if event is InputEventScreenDrag:
			position -= (event.relative * 0.2) * zoom.x
		
		if Input.is_action_just_pressed("+g"):
			world.generate_island()
	
	if mode == "build" && G.celltype.x > -1:
		cursor.visible = true
		cursor.position = G.globalpos
		cursor.modulate = Color(0.0,222.0,0.0,0.5)
		
		if event is InputEventScreenTouch:
			if event.is_pressed():
				trybuild(G.cellpos, G.selectbuild)
	
	if mode == "delete" && G.celltype.x > -1:
		cursor.visible = true
		cursor.position = G.globalpos
		cursor.modulate = Color(255.0,0.0,0.0,0.5)
		
		if event is InputEventScreenTouch:
			if event.is_pressed():
				trydelete(G.globalpos)
				print(G.globalpos)
				

func trydelete(pos):
	for e in world.get_child_count(): #looking for object on cell
		var object = world.get_child(e)
		
		if object.position == pos && object.name != "3dcursor":

			object.queue_free()
			world.nobuild.erase(pos)
			break
			
func trybuild(pos,type) -> void:
	var clickpos = world.local_to_map(get_global_mouse_position())
	var id = G.buildlist.find(type)
	#check allowed materials
	if world.get_cell_atlas_coords(clickpos) == G.buildlist[id + 1]:
		if !world.nobuild.has(world.map_to_local(pos)): #check if occupied
			build(G.globalpos,type)
		else:
			print_rich("[color=red]Cell is occupied!!![/color]")
	else:
		print_rich("[color=red]Can't build on this material!!![/color]")

func build(pos,type):
	match type:
		"coal":
			var instcoalfac = coalfac.instantiate()
			instcoalfac.position = pos
			world.add_child(instcoalfac)
			world.nobuild.append(pos)
		"warehouse":
			var instwarehouse = warehouse.instantiate()
			instwarehouse.position = pos
			world.add_child(instwarehouse)
			world.nobuild.append(pos)
	G.selectbuild = "none"
	print_rich("[color=green]cell avaible! building...[/color]")
	

func _physics_process(delta: float) -> void:
	world.get_node("water").position.x = position.x - 1111
	world.get_node("water").position.y = position.y - 1111
	
