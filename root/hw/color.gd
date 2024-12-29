# COLOR
extends RefCounted

# Alias
const BLACK = 0
const DARK_BLUE = 1
const DARK_PURPLE = 2
const DARK_GREEN = 3
const BROWN = 4
const DARK_GRAY = 5
const GRAY = 6
const WHITE = 7
const RED = 8
const ORANGE = 9
const YELLOW = 10
const GREEN = 11
const BLUE = 12
const INDIGO = 13
const PINK = 14
const PEACH = 15

const PALETTE = [ # PICO-8 palette
	Color8(0, 0, 0), # Black
	Color8(29, 43, 83), # Dark Blue
	Color8(126, 37, 83), # Dark Purple
	Color8(0, 135, 81), # Dark Green
	Color8(171, 82, 54), # Brown
	Color8(95, 87, 79), # Dark Gray
	Color8(194, 195, 199), # Light Gray
	Color8(255, 241, 232), # White
	Color8(255, 0, 77), # Red
	Color8(255, 163, 0), # Orange
	Color8(255, 236, 39), # Yellow
	Color8(0, 228, 54), # Green
	Color8(41, 173, 255), # Blue
	Color8(131, 118, 156), # Indigo
	Color8(255, 119, 168), # Pink
	Color8(255, 204, 170), # Peach
]

#const PALETTE = [ # SWEETIE-16 palette
	#Color8(26, 28, 44),  # 0 Black
	#Color8(93, 39, 93),  # 1 Purple
	#Color8(177, 49, 83), # 2 Red
	#Color8(239, 125, 87), # 3 Orange
	#Color8(255, 205, 117), # 4 Yellow
	#Color8(167, 240, 112), # 5 Light Green
	#Color8(56, 183, 100), # 6 Green
	#Color8(37, 113, 121), # 7 Dark Green
	#Color8(41, 54, 102),  # 8 Dark Blue
	#Color8(59, 92, 201),  # 9 Blue
	#Color8(65, 166, 246), # 10 Light Blue
	#Color8(115, 239, 247), # 11 Cyan
	#Color8(244, 244, 244), # 12 White
	#Color8(148, 176, 194), # 13 Light Grey
	#Color8(86, 108, 134),  # 14 Grey
	#Color8(51, 51, 87),    # 15 Dark Grey
#]

#const PALETTE = [ # SWEETIE-16 palette reordered
	#Color8(26, 28, 44), # 0 Black
	#Color8(51, 51, 87), # 1 Dark Grey
	#Color8(86, 108, 134), # 2 Grey
	#Color8(148, 176, 194), # 3 Light Grey
	#Color8(244, 244, 244), # 4 White
	#Color8(93, 39, 93), # 5 Purple
	#Color8(177, 49, 83), # 6 Red
	#Color8(239, 125, 87), # 7 Orange
	#Color8(255, 205, 117), # 8 Yellow
	#Color8(37, 113, 121), # 9 Dark Green
	#Color8(56, 183, 100), # 10 Green
	#Color8(167, 240, 112), # 11 Light Green
	#Color8(41, 54, 102), # 12 Dark Blue
	#Color8(59, 92, 201), # 13 Blue
	#Color8(65, 166, 246), # 14 Light Blue
	#Color8(115, 239, 247), # 15 Cyan
#]

static var _mask: int = 0b0000_0000_0000_0000_0000_0000_0000_0001 # Bitmask

func mask(color: int = -1, hide: bool = false) -> void:
	if color == -1:
		_mask = 1
	elif hide:
		_mask |= (1 << color)
	else:
		_mask &= ~(1 << color)
