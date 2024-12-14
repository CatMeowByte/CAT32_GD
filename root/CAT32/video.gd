# DISPLAY
extends RefCounted

# Dependency
static var FONT
static var COLOR

const W = 120
const HVIEW = 120
const HBAR = 20
const SPRITE_SIZE = 128 # Square

const MEM_VIEW = 0
const MEM_TOP = 1
const MEM_BOT = 2

static var _screen: TextureRect
static var _image: Image
static var _texture: ImageTexture

static var mem: PackedByteArray # Pointer
static var H: int # Simulate constant
static var mem_top: PackedByteArray
static var mem_view: PackedByteArray
static var mem_bot: PackedByteArray

static var sprite: PackedByteArray

static var cam: PackedInt32Array
static var text_wrap: bool

func _reset():
	sprite.fill(0)
	cam = [0, 0]
	text_wrap = false

func _setup() -> void:
	_image = Image.create_empty(W, HBAR + HVIEW + HBAR, false, Image.FORMAT_RGB8)
	_texture = ImageTexture.create_from_image(_image)
	_screen.texture = _texture

	mem_top.resize((W * HBAR) / 2)
	mem_view.resize((W * HVIEW) / 2)
	mem_bot.resize((W * HBAR) / 2)
	sprite.resize((SPRITE_SIZE * SPRITE_SIZE) / 2)

	mem_top.fill(0)
	mem_view.fill(0)
	mem_bot.fill(0)
	sprite.fill(0)

	memsel()


func memsel(id: int = MEM_VIEW) -> void:
	cam = [0, 0]
	if id == MEM_VIEW:
		mem = mem_view
		H = HVIEW
	elif id == MEM_TOP:
		mem = mem_top
		H = HBAR
	else: # MEM_BOT
		mem = mem_bot
		H = HBAR


func camera(x: int = 0, y: int = 0) -> PackedInt32Array:
	var p: PackedInt32Array = cam

	cam = [x, y]

	return p


func _pixel_get(x: int, y: int) -> int:
	if x < 0 or x >= W or y < 0 or y >= H:
		return -1
	var i: int = (y * W + x) / 2
	return (mem[i] >> 4) if x % 2 == 0 else (mem[i] & 0x0F)


func _pixel_set(x: int, y: int, color: int) -> void:
	if x < 0 or x >= W or y < 0 or y >= H:
		return
	if (COLOR._mask & (1 << color)) != 0:
		return
	var i: int = int((y * W + x) / 2)
	var is_hnibble: bool = x % 2 == 0
	mem[i] = (
		(mem[i] & (0x0F if is_hnibble else 0xF0)) # Preserve the other nibble
		| ((color & 0x0F) << (4 if is_hnibble else 0)) # Set the desired nibble
	)


func pixel(x: int, y: int, color: int = -1) -> int:
	x -= cam[0]
	y -= cam[1]
	if x < 0 or x >= W or y < 0 or y >= H:
		return -1

	var i: int = int((y * W + x) / 2)
	var value: int = mem[i]
	var old_color: int = (value >> 4) if x % 2 == 0 else (value & 0x0F)

	if color != -1:
		_pixel_set(x, y, color)

	return old_color


func line(x1: int, y1: int, x2: int, y2: int, color: int) -> void:
	x1 -= cam[0]
	y1 -= cam[1]
	x2 -= cam[0]
	y2 -= cam[1]
	var dx: int = abs(x2 - x1)
	var dy: int = abs(y2 - y1)
	var sx: int = 1 if x1 < x2 else -1
	var sy: int = 1 if y1 < y2 else -1
	var err: int = dx - dy

	while true:
		_pixel_set(x1, y1, color)

		if x1 == x2 and y1 == y2:
			break

		var e2: int = err * 2
		if e2 > -dy:
			err -= dy
			x1 += sx
		if e2 < dx:
			err += dx
			y1 += sy


func rect(x: int, y: int, width: int, height: int, color: int, fill: bool = false) -> void:
	x -= cam[0]
	y -= cam[1]
	if x >= W or y >= H or x + width <= 0 or y + height <= 0:
		return

	var x_start: int = max(0, x)
	var x_end: int = min(W, x + width)
	var y_start: int = max(0, y)
	var y_end: int = min(H, y + height)

	if fill:
		for scan_y in range(y_start, y_end):
			for scan_x in range(x_start, x_end):
				_pixel_set(scan_x, scan_y, color)
	else:
		for scan_x in range(x_start, x_end):
			_pixel_set(scan_x, y_start, color) # Top
			_pixel_set(scan_x, y_end - 1, color) # Bottom

		for scan_y in range(y_start + 1, y_end - 1):
			_pixel_set(x_start, scan_y, color) # Left
			_pixel_set(x_end - 1, scan_y, color) # Right


func text(x: int, y: int, string: String, color: int, background: int = 0) -> void:
	x -= cam[0]
	y -= cam[1]
	var current_x: int = x
	var current_y: int = y

	for ch in string:
		if ch == "\n": # Newline
			current_x = x
			current_y += FONT.H
			continue

		var ordinal: int = ch.unicode_at(0)

		# Wrapping
		if text_wrap:
			if current_x >= W:
				if ch == " ": # Space
					continue
				current_x = x
				current_y += FONT.H

		character(current_x, current_y, ordinal, color, background)
		current_x += FONT.W


func character(x: int, y: int, ordinal: int, color: int, background: int = 0) -> void:
	if x < -FONT.W or x >= W or y < -FONT.H or y >= H:
		return

	var bits: int = FONT.CHAR.get(ordinal, 0)
	for py in range(FONT.H):
		for px in range(FONT.W):
			var on: bool = (bits >> (py * FONT.W + px)) & 1
			var tx: int = x + px
			var ty: int = y + py
			if tx < 0 or tx >= W or ty < 0 or ty >= H:
				continue
			_pixel_set(tx, ty, color if on else background)

func blit(
	src: PackedByteArray,
	src_size_w: int, src_size_h: int,
	src_x: int, src_y: int, src_w: int, src_h: int,
	dest_size_w: int, dest_size_h: int,
	dest_x: int, dest_y: int, dest_w: int, dest_h: int,
	rotation: int = 0
) -> void:
	dest_x -= cam[0]
	dest_y -= cam[1]

	# Determine if flipping is required based on destination size
	var flip_h: bool = dest_w < 0
	var flip_v: bool = dest_h < 0

	# Use absolute values for destination width and height
	dest_w = abs(dest_w)
	dest_h = abs(dest_h)

	# Determine scaling factors for the source to destination mapping
	var scale_x: float = float(src_w) / float(dest_w)
	var scale_y: float = float(src_h) / float(dest_h)

	for y in range(dest_h):
		if dest_y + y < 0 or dest_y + y >= dest_size_h:
			continue

		for x in range(dest_w):
			if dest_x + x < 0 or dest_x + x >= dest_size_w:
				continue

			# Calculate source coordinates based on scaling, flip, and rotation
			var sx: int
			var sy: int

			if rotation == 0:
				sx = int(src_x + (src_w - 1 - x * scale_x) if flip_h else src_x + x * scale_x)
				sy = int(src_y + (src_h - 1 - y * scale_y) if flip_v else src_y + y * scale_y)
			elif rotation == 1:
				sx = int(src_x + (src_h - 1 - y * scale_y) if not flip_v else src_x + y * scale_y)
				sy = int(src_y + (src_w - 1 - x * scale_x) if flip_h else src_y + x * scale_x)
			elif rotation == 2:
				sx = int(src_x + (src_w - 1 - x * scale_x) if not flip_h else src_x + x * scale_x)
				sy = int(src_y + (src_h - 1 - y * scale_y) if not flip_v else src_y + y * scale_y)
			elif rotation == 3:
				sx = int(src_x + (src_h - 1 - y * scale_y) if flip_v else src_x + y * scale_y)
				sy = int(src_y + (src_w - 1 - x * scale_x) if not flip_h else src_y + x * scale_x)

			if sx < 0 or sx >= src_size_w or sy < 0 or sy >= src_size_h:
				continue

			var i: int = (sy * src_size_w + sx) / 2

			if i < 0 or i >= src.size():
				continue

			var color: int = (src[i] >> 4) if sx % 2 == 0 else (src[i] & 0x0F)

			_pixel_set(dest_x + x, dest_y + y, color)


func clear(color: int = 0) -> void:
	mem.fill(((color & 0x0F) << 4) | (color & 0x0F))


func flip() -> void:
	for y in range(HBAR + HVIEW + HBAR):
		var buffer: PackedByteArray
		var oy: int
		if y < HBAR:
			buffer = mem_top
			oy = y
		elif y < HBAR + HVIEW:
			buffer = mem_view
			oy = y - HBAR
		else:
			buffer = mem_bot
			oy = y - HBAR - HVIEW

		for x in range(W):
			var memory_byte = buffer[int((oy * W + x) / 2)]
			_image.set_pixel(x, y, COLOR.PALETTE[((memory_byte >> 4) if (x % 2 == 0) else (memory_byte & 0x0F)) % COLOR.PALETTE.size()])

	_texture.update(_image)
