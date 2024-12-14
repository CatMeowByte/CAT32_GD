# FONT
extends Object

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
