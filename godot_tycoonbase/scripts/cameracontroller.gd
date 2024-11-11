extends Camera2D
#cell types:
	#[6,2] coal
	
	#[0,0]
	#[1,0] grass
	
	#[2,0] sand

var mode = "view" # [build , view]
var selectbuild = "warehouse"

@onready var cursor = get_parent().get_node("3dcursor")

@onready var warehouse = preload("res://scenes/warehouse.tscn")
@onready var coalfac = preload("res://scenes/coalfactory.tscn")

func _input(event: InputEvent) -> void:
	
	$debugtext.text = str(
		"celltype: " , G.celltype, 
		"\ncellglobalpos: ", G.globalpos,
		"\nmode: ", mode)
	
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
	
	G.clickpos = get_global_mouse_position()
	G.cellpos = get_parent().local_to_map(Vector2(G.clickpos.x,G.clickpos.y))
	G.celltype = get_parent().get_cell_atlas_coords(G.cellpos)
	G.globalpos = get_parent().map_to_local(G.cellpos)

	if mode == "view":
		cursor.visible = false
		if event is InputEventScreenDrag:
			position -= (event.relative * 0.2) * zoom.x
			
	
	if mode == "build" && G.celltype.x > -1:
		cursor.visible = true
		cursor.position = G.globalpos
		cursor.modulate = Color(0.0,222.0,0.0,0.5)
		
		if event is InputEventScreenTouch:
			if event.is_pressed():
				trybuild(G.globalpos * 0.1, selectbuild)
	
	if mode == "delete" && G.celltype.x > -1:
		cursor.visible = true
		cursor.position = G.globalpos
		cursor.modulate = Color(255.0,0.0,0.0,0.5)
		
		if event is InputEventScreenTouch:
			if event.is_pressed():
				trydelete(G.globalpos)
				

func trydelete(pos):
	for e in get_parent().get_child_count(): #looking for object on cell
		var object = get_parent().get_child(e)
		
		if object.position == pos && object.name != "3dcursor":

			object.queue_free()
			G.nobuild.erase(pos * 0.1)
			break
			
func trybuild(pos,type) -> void:
	var clickpos = get_parent().local_to_map(get_global_mouse_position())
	var id = G.buildlist.find(type)
	#check allowed materials
	if get_parent().get_cell_atlas_coords(clickpos) == G.buildlist[id + 1]:
		if !G.nobuild.has(pos): #check if occupied
			build(pos,type)
		else:
			print_rich("[color=red]Cell is occupied!!![/color]")
	else:
		print_rich("[color=red]Can't build on this material!!![/color]")

func build(pos,type):
	match type:
		"coal":
			var instcoalfac = coalfac.instantiate()
			instcoalfac.position = pos * 10
			get_parent().add_child(instcoalfac)
			G.nobuild.append(pos)
		"warehouse":
			var instwarehouse = warehouse.instantiate()
			instwarehouse.position = pos * 10
			get_parent().add_child(instwarehouse)
			G.nobuild.append(pos)
	print_rich("[color=green]cell avaible! building...[/color]")
	

func _physics_process(delta: float) -> void:
	get_parent().get_node("water").position.x = position.x - 1111
	get_parent().get_node("water").position.y = position.y - 1111
	
