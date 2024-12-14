class_name CAT32
extends Node

# NOTICE:
# do better return in exec
# consider aliasing
# dbus message

const ROOT: String = "res://root/"

const FPS: int = 30
const SAMPLE: float = 11025

static var process: Timer
static var service: Timer

var FONT = load(ROOT.path_join("/CAT32/font.gd")).new()
var COL = load(ROOT.path_join("/CAT32/color.gd")).new()
var DIS = load(ROOT.path_join("/CAT32/video.gd")).new()
var SND = load(ROOT.path_join("/CAT32/audio.gd")).new()
var IOP = load(ROOT.path_join("/CAT32/io.gd")).new()
var DIR = load(ROOT.path_join("/CAT32/storage.gd")).new()
var BTN = load(ROOT.path_join("/CAT32/button.gd")).new()


func _ready() -> void:
	# Dependency
	DIS.FONT = FONT
	DIS.COLOR = COL
	SND.FPS = FPS
	SND.SAMPLE = SAMPLE
	DIR.ROOT = ROOT

	_reset()

	var node: Node

	node = TextureRect.new()
	node.set_name("Display")
	node.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	node.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	node.set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
	add_child(node)
	DIS._screen = node

	node = AudioStreamPlayer.new()
	node.set_name("Speaker")
	node.set_stream(AudioStreamGenerator.new())
	add_child(node)
	SND._speaker = node

	DIR._crawler = DirAccess.open(ROOT)

	DIS._setup()
	SND._setup()

	process = Timer.new()
	process.set_name("Process")
	process.set_wait_time(1.0 / FPS)
	process.set_autostart(true)
	add_child(process)

	run("/boot.cat.gd")

	service = Timer.new()
	service.set_name("Service")
	service.set_wait_time(1.0 / FPS)
	service.set_autostart(true)
	add_child(service)

	service.set_script(load(ROOT.path_join("service.cat.gd")))

	if not service.timeout.is_connected(BTN._process_state):
		service.connect("timeout", BTN._process_state)

	if service.has_method("update"):
		if not service.timeout.is_connected(service.update):
			service.connect("timeout", service.update)

	if service.has_method("init"):
		service.init()


func _process(delta: float) -> void:
	DIS.memsel()

	if process:
		if process.has_method("draw"):
			process.draw()

	#if service:
	if service.has_method("draw"):
		service.draw()

	DIS.flip()

	SND._process_buffer(delta)

# Reset value to default
func _reset():
	DIS._reset()
	BTN._reset()

func run(script: String, arguments: Dictionary = {}) -> void:
	_reset()
	if process.has_method("update"):
		if process.timeout.is_connected(process.update):
			process.disconnect("timeout", process.update)

	process.set_script(load(ROOT.path_join(script)))

	for key in arguments.keys():
		if key in process:
			process.set(key, arguments[key])
		else:
			o("Aguments \"" + key + "\" does not exist.")

	if "gfx" in process:
		DIS.sprite = process.gfx.strip_escapes().hex_decode()
		#print(DIS.sprite.hex_encode()) # TODO: this is how to store it back

	if process.has_method("init"):
		process.init()

	if process.has_method("update"):
		if not process.timeout.is_connected(process.update):
			process.connect("timeout", process.update)

func exec(script: String, arguments: Dictionary = {}) -> Variant:
	var command = load(ROOT.path_join(script)).new()

	for key in arguments.keys():
		if key in command:
			command.set(key, arguments[key])
		else:
			o("Aguments \"" + key + "\" does not exist.")

	if command.has_method("execute"):
		return command.execute()
	else:
		o("Commands \"" + script + "\" has no execute() function.")
	return

func timer(duration: float) -> void:
	await get_tree().create_timer(duration).timeout

func random(value: float = 1.0) -> float:
	return randf() * value

func o(
	arg0:Variant,
	arg1:Variant = null,
	arg2:Variant = null,
	arg3:Variant = null,
	arg4:Variant = null,
	arg5:Variant = null,
	arg6:Variant = null,
	arg7:Variant = null,
	) -> void:
	var args: Array[Variant] = [
		arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7,
	].filter(func(value:Variant) -> bool: return value != null)

	print("%s ".repeat(args.size()).strip_edges() % args)

func hi() -> void:
	print("Hi, all!")
