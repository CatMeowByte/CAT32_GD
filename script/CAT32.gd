class_name CAT32
extends Node

# TODO:
# strip complexity, keep it minimal
# make pico8 as a base
# consider betwween class based or global func

@export_file() var init_file: String = "res://script/boot.cat.gd"

const FPS: int = 30
const SAMPLE: float = 11025

static var process: Node

static var _tick_update: bool = false
static var _tick_draw: bool = false

class COL:
	static var BLACK: int = 0
	static var DARK_BLUE: int = 1
	static var DARK_PURPLE: int = 2
	static var DARK_GREEN: int = 3
	static var BROWN: int = 4
	static var DARK_GRAY: int = 5
	static var LIGHT_GRAY: int = 6
	static var WHITE: int = 7
	static var RED: int = 8
	static var ORANGE: int = 9
	static var YELLOW: int = 10
	static var GREEN: int = 11
	static var BLUE: int = 12
	static var INDIGO: int = 13
	static var PINK: int = 14
	static var PEACH: int = 15


	const PAL = [ # PICO-8 palette
		Color8(0, 0, 0),         # Black
		Color8(29, 43, 83),      # Dark Blue
		Color8(126, 37, 83),     # Dark Purple
		Color8(0, 135, 81),      # Dark Green
		Color8(171, 82, 54),     # Brown
		Color8(95, 87, 79),      # Dark Gray
		Color8(194, 195, 199),   # Light Gray
		Color8(255, 241, 232),   # White
		Color8(255, 0, 77),      # Red
		Color8(255, 163, 0),     # Orange
		Color8(255, 236, 39),    # Yellow
		Color8(0, 228, 54),      # Green
		Color8(41, 173, 255),    # Blue
		Color8(131, 118, 156),   # Indigo
		Color8(255, 119, 168),   # Pink
		Color8(255, 204, 170)    # Peach
	]


	static var _mask: int = 1 # Bit

	static func mask(color: int = -1, hide: bool = false) -> void:
		if color == -1:
			_mask = 1
		elif hide:
			_mask |= (1 << color)
		else:
			_mask &= ~(1 << color)

class FONT:
	const W: int = 4
	const H: int = 8
	const CHAR: Dictionary = {
		9617: 0b00000101000001010000010100000101, # ░
		9618: 0b10100101101001011010010110100101, # ▒
		9619: 0b10101111101011111010111110101111, # ▓
		9608: 0b11111111111111111111111111111111, # █
		9472: 0b00000000000011110000000000000000, # ─
		9474: 0b00100010001000100010001000100010, # │
		9484: 0b00100010001011100000000000000000, # ┌
		9488: 0b00100010001000110000000000000000, # ┐
		9492: 0b00000000000011100010001000100010, # └
		9496: 0b00000000000000110010001000100010, # ┘
		9500: 0b00100010001011100010001000100010, # ├
		9508: 0b00100010001000110010001000100010, # ┤
		9516: 0b00100010001011110000000000000000, # ┬
		9524: 0b00000000000011110010001000100010, # ┴
		9532: 0b00100010001011110010001000100010, # ┼
		8226: 0b00000000000000100000000000000000, # •
		176: 0b00000000000001110101011100000000, # °
		169: 0b00001111100111011001111100000000, # ©
		174: 0b00001111110111011001111100000000, # ®
		8482: 0b00001010111011100010011100000000, # ™
		65533: 0b11111111110111111011100111111111, # �
		33: 0b00000000001000000010001000000000, # !
		34: 0b00000000000000000101010100000000, # "
		35: 0b00000101011101010111010100000000, # #
		36: 0b00000010011100100111001000000000, # $
		37: 0b00000000010100110110010100000000, # %
		38: 0b00000000011001010011011000000000, # &
		39: 0b00000000000000000010001000000000, # '
		40: 0b00000100001000100010010000000000, # (
		41: 0b00000010010001000100001000000000, # )
		42: 0b00000000000001010010010100000000, # *
		43: 0b00000000001001110010000000000000, # +
		44: 0b00000010001000000000000000000000, # ,
		45: 0b00000000000001110000000000000000, # -
		46: 0b00000000001000000000000000000000, # .
		47: 0b00000001000100100100010000000000, # /
		48: 0b00000000001101010101011000000000, # 0
		49: 0b00000000011100100010001100000000, # 1
		50: 0b00000000011100100100011100000000, # 2
		51: 0b00000000011101000110011100000000, # 3
		52: 0b00000000010001110101010100000000, # 4
		53: 0b00000000011101000011011100000000, # 5
		54: 0b00000000011101110001011100000000, # 6
		55: 0b00000000010001000100011100000000, # 7
		56: 0b00000000011101010111011100000000, # 8
		57: 0b00000000010001110101011100000000, # 9
		58: 0b00000000001000000010000000000000, # :
		59: 0b00000010001000000010000000000000, # ;
		60: 0b00000100001000010010010000000000, # <
		61: 0b00000000011100000111000000000000, # =
		62: 0b00000001001001000010000100000000, # >
		63: 0b00000000001000000100011100000000, # ?
		64: 0b00000000011000010101001000000000, # @
		65: 0b00000000010101110101011100000000, # A
		66: 0b00000000011101010111001100000000, # B
		67: 0b00000000011100010001011100000000, # C
		68: 0b00000000001101010101001100000000, # D
		69: 0b00000000011100010011011100000000, # E
		70: 0b00000000000100110001011100000000, # F
		71: 0b00000000011101010001011100000000, # G
		72: 0b00000000010101110101010100000000, # H
		73: 0b00000000011100100010011100000000, # I
		74: 0b00000000011101010100010000000000, # J
		75: 0b00000000010100110101010100000000, # K
		76: 0b00000000011100010001000100000000, # L
		77: 0b00000000010101010111011100000000, # M
		78: 0b00000000010101010101011100000000, # N
		79: 0b00000000011101010101011100000000, # O
		80: 0b00000000000101110101011100000000, # P
		81: 0b00000000010001110101011100000000, # Q
		82: 0b00000000010100110101011100000000, # R
		83: 0b00000000011101000001011100000000, # S
		84: 0b00000000001000100010011100000000, # T
		85: 0b00000000011101010101010100000000, # U
		86: 0b00000000001001010101010100000000, # V
		87: 0b00000000011101110101010100000000, # W
		88: 0b00000000010100100101010100000000, # X
		89: 0b00000000001001110101010100000000, # Y
		90: 0b00000000011100010100011100000000, # Z
		91: 0b00000110001000100010011000000000, # [
		92: 0b00000100010000100001000100000000, # \
		93: 0b00000110010001000100011000000000, # ]
		94: 0b00000000000000000101001000000000, # ^
		95: 0b00000000011100000000000000000000, # _
		96: 0b00000000000000000100001000000000, # `
		97: 0b00000000011101010110000000000000, # a
		98: 0b00000000011101010111000100000000, # b
		99: 0b00000000011100010111000000000000, # c
		100: 0b00000000011101010111010000000000, # d
		101: 0b00000000001101010111000000000000, # e
		102: 0b00000001001100010111000000000000, # f
		103: 0b00000110011101010111000000000000, # g
		104: 0b00000000010101010111000100000000, # h
		105: 0b00000000001000100000001000000000, # i
		106: 0b00000011001000100000001000000000, # j
		107: 0b00000000010100110101000100000000, # k
		108: 0b00000000011000100010001000000000, # l
		109: 0b00000000010101110111000000000000, # m
		110: 0b00000000010101010111000000000000, # n
		111: 0b00000000011101010111000000000000, # o
		112: 0b00000001011101010111000000000000, # p
		113: 0b00000100011101010111000000000000, # q
		114: 0b00000000000100010111000000000000, # r
		115: 0b00000000001100100110000000000000, # s
		116: 0b00000000011000100111001000000000, # t
		117: 0b00000000011101010101000000000000, # u
		118: 0b00000000001001010101000000000000, # v
		119: 0b00000000011101110101000000000000, # w
		120: 0b00000000010100100101000000000000, # x
		121: 0b00000110011101010101000000000000, # y
		122: 0b00000000011000100011000000000000, # z
		123: 0b00000110001000110010011000000000, # {
		124: 0b00000010001000100010001000000000, # |
		125: 0b00000011001001100010001100000000, # }
		126: 0b00000000000000110110000000000000, # ~
	}


class DIS:
	const W = 120
	const H = 160
	const SPRITE_SIZE = 128 # Square

	static var node_screen_main: TextureRect
	static var img: Image
	static var tex: ImageTexture

	static var memory: PackedByteArray
	static var sprite: PackedByteArray


	static func _setup() -> void:
		img = Image.create_empty(W, H, false, Image.FORMAT_RGB8)
		tex = ImageTexture.create_from_image(img)
		node_screen_main.texture = tex

		memory.resize((W * H) / 2)
		memory.fill(0)

		sprite.resize((SPRITE_SIZE * SPRITE_SIZE) / 2)


	static func _get_pixel(x: int, y: int) -> int:
		if x < 0 or x >= DIS.W or y < 0 or y >= DIS.H:
			return -1
		var i: int = (y * DIS.W + x) / 2
		return (DIS.memory[i] >> 4) if x % 2 == 0 else (DIS.memory[i] & 0x0F)


	static func _set_pixel(x: int, y: int, color: int) -> void:
		if (COL._mask & (1 << color)) != 0:
			return
		var i: int = int((y * DIS.W + x) / 2)
		var is_high_nibble: bool = x % 2 == 0
		DIS.memory[i] = (
			(DIS.memory[i] & (0x0F if is_high_nibble else 0xF0))  # Preserve the other nibble
			| ((color & 0x0F) << (4 if is_high_nibble else 0))    # Set the desired nibble
		)


	static func pixel(x: int, y: int, color: int = -1) -> int:
		# Check bounds
		if x < 0 or x >= DIS.W or y < 0 or y >= DIS.H:
			return -1

		# Retrieve the color first
		var i: int = int((y * DIS.W + x) / 2)
		var value: int = DIS.memory[i]
		var old_color: int = (value >> 4) if x % 2 == 0 else (value & 0x0F)

		# Optionally set a new color
		if color != -1:
			DIS._set_pixel(x, y, color)

		# Return the original color
		return old_color


	static func line(x1: int, y1: int, x2: int, y2: int, color: int) -> void:
		var dx: int = abs(x2 - x1)
		var dy: int = abs(y2 - y1)
		var sx: int = 1 if x1 < x2 else -1
		var sy: int = 1 if y1 < y2 else -1
		var err: int = dx - dy

		while true:
			DIS._set_pixel(x1, y1, color)

			if x1 == x2 and y1 == y2:
				break

			var e2: int = err * 2
			if e2 > -dy:
				err -= dy
				x1 += sx
			if e2 < dx:
				err += dx
				y1 += sy


	static func rect(x: int, y: int, width: int, height: int, color: int, fill: bool = false) -> void:
		if x >= DIS.W or y >= DIS.H or x + width <= 0 or y + height <= 0:
			return

		var x_start: int = max(0, x)
		var x_end: int = min(DIS.W, x + width)
		var y_start: int = max(0, y)
		var y_end: int = min(DIS.H, y + height)

		if fill:
			for scan_y in range(y_start, y_end):
				for scan_x in range(x_start, x_end):
					DIS._set_pixel(scan_x, scan_y, color)
		else:
			for scan_x in range(x_start, x_end):
				DIS._set_pixel(scan_x, y_start, color)  # Top edge
				DIS._set_pixel(scan_x, y_end - 1, color)  # Bottom edge

			for scan_y in range(y_start + 1, y_end - 1):
				DIS._set_pixel(x_start, scan_y, color)  # Left edge
				DIS._set_pixel(x_end - 1, scan_y, color)  # Right edge


	static func text(x: int, y: int, string: String, color: int, background: int = COL.BLACK) -> void:
		var current_x = x
		var current_y = y

		for ch in string:
			if ch == "\n":  # Handle newline
				current_x = x
				current_y += FONT.H
				continue

			var ordinal: int = ch.unicode_at(0)

			# Handle wrapping if the text goes off the right edge
			if current_x >= DIS.W:
				if ch == " ":  # Handle space
					continue
				current_x = x
				current_y += FONT.H

			DIS.character(current_x, current_y, ordinal, color, background)
			current_x += FONT.W


	static func character(x: int, y: int, ordinal: int, color: int, background: int = COL.BLACK) -> void:
		#if x < 0 or x + FONT.W >= DIS.W or y < 0 or y + FONT.H >= DIS.H:
			#return

		var bits: int = FONT.CHAR.get(ordinal, 0)
		for py in range(FONT.H):
			for px in range(FONT.W):
				var on: bool = (bits >> (py * FONT.W + px)) & 1
				var tx: int = x + px
				var ty: int = y + py
				if tx < 0 or tx >= DIS.W or ty < 0 or ty >= DIS.H:
					continue
				DIS._set_pixel(tx, ty, color if on else background)  # Immediate memory update


	static func blit(src_x: int, src_y: int, dest_x: int, dest_y: int, dest_w: int, dest_h: int) -> void:
		#DIS.rect(dest_x - src_x, dest_y - src_y, src_w, src_h, COL.DARK_GRAY, true) # Debug, do not delete
		var src: PackedByteArray = sprite

		for y in range(dest_h):
			# Skip rows out of bounds
			if dest_y + y < 0 or dest_y + y >= DIS.H:
				continue

			for x in range(dest_w):
				# Skip columns out of bounds
				if dest_x + x < 0 or dest_x + x >= DIS.W:
					continue

				# Source pixel coordinates
				var sx: int = src_x + x
				var sy: int = src_y + y

				# Skip out-of-bounds source pixels
				if sx < 0 or sx >= SPRITE_SIZE or sy < 0 or sy >= SPRITE_SIZE:
					continue

				# Calculate source memory index
				var i: int = (sy * SPRITE_SIZE + sx) / 2

				# Ensure index is within bounds of the source array
				if i < 0 or i >= src.size():
					continue

				# Extract the pixel color
				var color: int = (src[i] >> 4) if sx % 2 == 0 else (src[i] & 0x0F)

				# Set the pixel in the destination
				_set_pixel(dest_x + x, dest_y + y, color)



	static func clear(color: int = 0) -> void:
		memory.fill(((color & 0x0F) << 4) | (color & 0x0F))


	static func flip() -> void:
		# Loop through each pixel in the display memory
		for y in range(H):
			for x in range(W):
				# Calculate memory index and nibble
				var index: int = int((y * W + x) / 2)
				var is_high_nibble: bool = (x % 2 == 0)
				var value: int = memory[index]

				# Extract the color index
				var color_index: int = (value >> 4) if is_high_nibble else (value & 0x0F)

				# Set the pixel color in the Image
				img.set_pixel(x, y, COL.PAL[color_index % COL.PAL.size()])

		# Update the ImageTexture with the modified Image
		tex.update(img)


class SND:
	const NOTE_FREQUENCY = {
		"C": 261.63,
		"C#": 277.18,
		"D": 293.66,
		"D#": 311.13,
		"E": 329.63,
		"F": 349.23,
		"F#": 369.99,
		"G": 392.00,
		"G#": 415.30,
		"A": 440.00,
		"A#": 466.16,
		"B": 493.88
	}

	static var node_speaker: AudioStreamPlayer
	static var volume: float = 1.0
	static var play: bool = true

	static var _buffer: Array[Array] = [] # Fill with frequency and duration
	static var _frequency: float = 0.0
	static var _duration: float = 0.0
	static var _phase: float = 0.0

	static var playback: AudioStreamGeneratorPlayback


	static func _setup() -> void:
		node_speaker.get_stream().set_mix_rate(SAMPLE)
		node_speaker.get_stream().set_buffer_length(1.0 / FPS)
		node_speaker.play()
		playback = node_speaker.get_stream_playback()


	static func _process_buffer(delta: float) -> void:
		if not play:
			return

		if _duration <= 0.0:
			if not _buffer:
				play = false
				return

			# read
			_frequency = _buffer[0][0]
			_duration = _buffer[0][1] + _duration
			_buffer.pop_front()
		else:
			_duration -= delta

			# buffer
			for i in range(playback.get_frames_available()):
				playback.push_frame(Vector2.ONE * sin(_phase * TAU) * volume)
				_phase = fmod(_phase + (_frequency / SAMPLE), 1.0)


	static func get_freq(note: String, octave: int) -> float:
		var key = note.to_upper()
		if key not in NOTE_FREQUENCY.keys():
			return 0.0

		return NOTE_FREQUENCY[key] * (2 ** (octave - 4))


	static func play_tone(frequency: float, duration: float, immediate: bool = false) -> void:
		if immediate:
			_buffer.clear()

		_buffer.append([frequency, duration])
		play = true


class IOP:
	pass


class BTN:
	const CANCEL: int = 1 << 0
	const ACCEPT: int = 1 << 1
	const CONTEXT: int = 1 << 2
	const SYSTEM: int = 1 << 3
	const UP: int = 1 << 4
	const DOWN: int = 1 << 5
	const LEFT: int = 1 << 6
	const RIGHT: int = 1 << 7

	static var state: int = 0 # bitmask


	static func pressed(button: int) -> bool:
		return (state & button) != 0


	static func _process_state() -> void:
		state = 0

		# UP
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
			state |= UP

		# DOWN
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			state |= DOWN

		# LEFT
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			state |= LEFT

		# RIGHT
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			state |= RIGHT

		# CANCEL
		if Input.is_key_pressed(KEY_SHIFT):
			state |= CANCEL

		# ACCEPT
		if Input.is_key_pressed(KEY_ENTER):
			state |= ACCEPT

		# CONTEXT
		if Input.is_key_pressed(KEY_E):
			state |= CONTEXT

		# SYSTEM
		if Input.is_key_pressed(KEY_Q):
			state |= SYSTEM


func _ready() -> void:
	var node: Node

	node = TextureRect.new()
	node.set_name("Display")
	node.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	node.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	node.set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
	add_child(node)
	DIS.node_screen_main = node

	node = AudioStreamPlayer.new()
	node.set_name("Speaker")
	node.set_stream(AudioStreamGenerator.new())
	add_child(node)
	SND.node_speaker = node

	DIS._setup()
	SND._setup()

	process = Node.new()
	process.set_name("Process")
	add_child(process)

	run(init_file)


func _process(delta: float) -> void:
	if not process:
		return

	if _tick_draw:
		if process.has_method("draw"):
			process.draw()
			DIS.flip()

	SND._process_buffer(delta)
	BTN._process_state()


func _run_process() -> void:
	if not process:
		return

	if _tick_update:
			process.update()


func run(script: String):
	for child in process.get_children():
		child.queue_free()

	process.set_script(load(script))

	_tick_update = false
	_tick_draw = false

	if "gfx" in process:
		DIS.sprite = process.gfx.strip_escapes().hex_decode()
		#print(DIS.sprite.hex_encode()) # TODO: this is how to store it back

	if process.has_method("init"):
		await process.init()

	_tick_update = true
	_tick_draw = true

	if process.has_method("update"):
		var t = Timer.new()
		t.connect("timeout", _run_process)
		t.set_wait_time(1.0 / FPS)
		t.set_autostart(true)
		process.add_child(t)


func timer(duration: float) -> void:
	await get_tree().create_timer(duration).timeout


func hi() -> void:
	print("Hi, all!")
