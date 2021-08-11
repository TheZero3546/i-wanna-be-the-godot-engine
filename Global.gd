extends Node

onready var music_node = get_tree().get_root().get_node("/root/Music")
onready var bgm = music_node.get_node("Bgm")
onready var death_sound = music_node.get_node("DeathSound")
onready var death_music = music_node.get_node("DeathMusic")
var music = [	preload("res://Assets/Music/GuyRock.ogg"),	#0
				preload("res://Assets/Music/Megaman.ogg"),	#1
				preload("res://Assets/Music/Miku.ogg")]		#2

onready var death_particles = preload("res://Src/Scenes/DeathParticles.tscn")

var music_volume = [	-10,	#0
						-20,	#1
						-10]	#2

var screens = [	"res://Src/Scenes/Menu.tscn",	#0
				"res://Src/Scenes/Test01.tscn", #1
				"res://Src/Scenes/Test02.tscn"] #2

var save_id = 0
var current_screen = 0
var save_position = Vector2(440,480)
var deaths = 0

func _ready():
	bgm.pause_mode = true
	bgm.stream = music[0]
	bgm.volume_db = music_volume[0]
	bgm.play()

func die(body):
	deaths += 1
	bgm.stream_paused = true
	death_music.play()
	DeathScreen.visible = true
	death_sound.play()
	
	var new_death_particles = death_particles.instance()
	new_death_particles.global_position = body.global_position
	body.queue_free()
	get_tree().get_root().get_node("Screen").add_child(new_death_particles)
	new_death_particles.emitting = true

func _input(event):
	if event.is_action_pressed("restart") and not (get_tree().current_scene.filename == "res://Src/Scenes/Title.tscn" or get_tree().current_scene.filename == "res://Src/Scenes/Menu.tscn"):
		reload()
	
	if event.is_action_pressed("reload_game"):
		DeathScreen.visible = false
		get_tree().change_scene("res://Src/Scenes/Title.tscn")
	
	if event.is_action_pressed("self_kill") and not (get_tree().current_scene.filename == "res://Src/Scenes/Title.tscn" or get_tree().current_scene.filename == "res://Src/Scenes/Menu.tscn"):
		die(get_tree().current_scene.get_node("Player"))

func teleport(_screen, _position):
	get_tree().change_scene(screens[_screen])
	yield(get_tree().create_timer(0.1), "timeout")
	current_screen = _screen
	get_node("/root/Screen").spawn(_position)

func save():
	save_id = current_screen
	var save_data = {
		"save_id" : save_id,
		"save_position_x" : save_position.x,
		"save_position_y" : save_position.y,
		"deaths" : deaths
	}
	var save_file = File.new()
	save_file.open("user://save.sav", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()

func load_game():
	var save_file = File.new()
	if not save_file.file_exists("user://save.sav"):
		return
	save_file.open("user://save.sav", File.READ)
	var load_data = parse_json(save_file.get_line())
	save_id = int(load_data["save_id"])
	save_position = Vector2(float(load_data["save_position_x"]), float(load_data["save_position_y"]))
	deaths = int(load_data["deaths"])
	
	save_file.close()

func reload():
	current_screen = save_id
	var new_scene = screens[save_id]
	get_tree().change_scene(new_scene)
	yield(get_tree().create_timer(0.1), "timeout")
	get_node("/root/Screen").spawn(save_position)
	death_music.stop()
	bgm.stream_paused = false
	DeathScreen.visible = false
