# BUTTON
extends RefCounted

# Alias
const CANCEL = 0
const ACCEPT = 1
const CONTEXT = 2
const SYSTEM = 3
const UP = 4
const DOWN = 5
const LEFT = 6
const RIGHT = 7

static var keybind = {
	CANCEL: [KEY_SHIFT, KEY_BACKSPACE],
	ACCEPT: [KEY_ENTER, KEY_SPACE],
	CONTEXT: [KEY_E, KEY_ASCIITILDE],
	SYSTEM: [KEY_Q, KEY_ESCAPE],
	UP: [KEY_W, KEY_UP],
	DOWN: [KEY_S, KEY_DOWN],
	LEFT: [KEY_A, KEY_LEFT],
	RIGHT: [KEY_D, KEY_RIGHT],
}

static var state: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0]

func _process_state() -> void:
	for i in range(8):
		if Input.is_key_pressed(keybind[i][0]) or Input.is_key_pressed(keybind[i][1]):
			state[i] += 1
		else:
			state[i] = 0

func is_pressed(button: int) -> bool:
	return state[button] > 0

func just_pressed(button: int) -> bool:
	return state[button] == 1

func get_repeat(button: int, delay: int = 15, interval: int = 5) -> bool:
	var duration = state[button]

	if duration == 1:
		return true
	if duration == delay:
		return true
	if duration > delay and (duration - delay) % interval == 0:
		return true

	return false
