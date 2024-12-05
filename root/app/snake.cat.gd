extends CAT32

const BODY_COUNT = 16
const FOOD_COUNT = 32
const MAP_SIZE = 30  # Size of the game map

var snake = []
var dir = [1 , 0]
var food = []
var f = 0
var boost = 1
var state = "menu"
var menu_sel = 0
var menu_items = ["Play", "Options", "Exit"]
var options_sel = 0
var options_items = ["Sound", "Food Glow"]
var sound_enabled = true
var highlight_food = true

func init():
	restart()

func update():
	if state == "menu" or state == "options":
		if f % 4 == 0:
			menu_input()
		f = (f + 1) % 4
	else:
		if f % (2 - boost) == 0:
			tick()
		f = (f + 1) % (2 - boost)

func menu_input():
	var sel = menu_sel if state == "menu" else options_sel
	var items_size = menu_items.size() if state == "menu" else options_items.size()

	if BTN.pressed(BTN.UP):
		sel = max(sel - 1, 0)
		play_sound(SND.get_freq("A", 4), 1.0 / 20.0)
	elif BTN.pressed(BTN.DOWN):
		sel = min(sel + 1, items_size - 1)
		play_sound(SND.get_freq("A", 4), 1.0 / 20.0)
	elif BTN.pressed(BTN.ACCEPT):
		if state == "menu":
			play_sound(SND.get_freq("G", 5), 1.0 / 20.0)
			play_sound(SND.get_freq("A", 6), 1.0 / 20.0)
			if sel == 0:
				state = "play"
			elif sel == 1:
				state = "options"
			elif sel == 2:
				get_tree().quit()
		elif state == "options":
			if sel == 0:
				sound_enabled = !sound_enabled
			elif sel == 1:
				highlight_food = !highlight_food
			play_sound(SND.get_freq("G", 5), 1.0 / 20.0)
			play_sound(SND.get_freq("A", 6), 1.0 / 20.0)
	elif BTN.pressed(BTN.CANCEL) and state == "options":
		state = "menu"
	elif BTN.pressed(BTN.CANCEL) and state == "play":
		state = "menu"

	if state == "menu":
		menu_sel = sel
	elif state == "options":
		options_sel = sel

func play_sound(freq, duration):
	if sound_enabled:
		SND.play_tone(freq, duration)

func tick():
	var head = [snake[0][0] + dir[0], snake[0][1] + dir[1]]
	snake.push_front(head)
	if head in food:
		food.erase(head)
		play_sound(SND.get_freq("C", 7), 1.0 / 30.0)
		spawn_food()
	else:
		snake.pop_back()

	# Collision with map boundaries
	if head[0] < 0 or head[1] < 0 or head[0] >= MAP_SIZE or head[1] >= MAP_SIZE:
		restart(1)

	for i in range(1, snake.size()):
		if head == snake[i]:
			restart(1)
			break

func input():
	boost = 0
	if BTN.pressed(BTN.UP) and dir != [0, 1]:
		if dir == [0, -1]:
			boost = 1
		dir = [0, -1]
	elif BTN.pressed(BTN.DOWN) and dir != [0, -1]:
		if dir == [0, 1]:
			boost = 1
		dir = [0, 1]
	elif BTN.pressed(BTN.LEFT) and dir != [1, 0]:
		if dir == [-1, 0]:
			boost = 1
		dir = [-1, 0]
	elif BTN.pressed(BTN.RIGHT) and dir != [-1, 0]:
		if dir == [1, 0]:
			boost = 1
		dir = [1, 0]
	elif BTN.pressed(BTN.CANCEL):
		state = "menu"

func draw():
	if state == "menu" or state == "options":
		draw_menu()
	else:
		input()
		draw_game()

func draw_menu():
	DIS.camera()
	DIS.clear(COL.DARK_PURPLE)
	var title = "SNAKE" if state == "menu" else "OPTIONS"
	DIS.text(8, 8, title, COL.WHITE)
	COL.mask(COL.BLACK, 0)
	COL.mask(COL.PINK, 1)
	var items = menu_items if state == "menu" else options_items
	var sel = menu_sel if state == "menu" else options_sel

	for i in range(items.size()):
		var fg = COL.WHITE if i == sel else COL.LIGHT_GRAY
		var bg = COL.BLACK if i == sel else COL.PINK
		var text = items[i]
		if state == "options":
			var value = "ON" if (i == 0 and sound_enabled) or (i == 1 and highlight_food) else "OFF"
			text += ": " + value
		DIS.text(8, 16 + (i * 8), text, fg, bg)
	COL.mask()

func draw_game():
	DIS.camera((-DIS.W + MAP_SIZE) / 2, (-DIS.H+ + MAP_SIZE) / 2)
	DIS.clear(COL.DARK_BLUE)
	DIS.rect(-1, -1, MAP_SIZE + 2, MAP_SIZE + 2, COL.DARK_GRAY)

	var score = str(snake.size() - BODY_COUNT)
	COL.mask(COL.BLACK, 0)
	DIS.text((MAP_SIZE / 2 - 2 * score.length()), -8, score, COL.WHITE, COL.BLACK)
	COL.mask()
	for d in food:
		if highlight_food and is_food_in_snake_path(d):
			DIS.rect(d[0] - 1, d[1] - 1, 3, 3, COL.DARK_GREEN)
			DIS.pixel(d[0], d[1], COL.GREEN)
		else:
			DIS.pixel(d[0], d[1], COL.DARK_GREEN)
	for s in snake:
		DIS.pixel(s[0], s[1], COL.WHITE)

func is_food_in_snake_path(food_pos):
	# Check if the food is in the direct path of the snake head
	var head = snake[0]
	if dir == [1, 0] and food_pos[1] == head[1] and food_pos[0] > head[0]:
		return true
	elif dir == [-1, 0] and food_pos[1] == head[1] and food_pos[0] < head[0]:
		return true
	elif dir == [0, 1] and food_pos[0] == head[0] and food_pos[1] > head[1]:
		return true
	elif dir == [0, -1] and food_pos[0] == head[0] and food_pos[1] < head[1]:
		return true
	return false

func spawn_food():
	while food.size() < FOOD_COUNT:
		var new_food = [int(random(MAP_SIZE)), int(random(MAP_SIZE))]
		if new_food not in snake and new_food not in food:
			food.append(new_food)

func restart(sound = 0):
	snake = []
	for s in range(BODY_COUNT):
		snake.append([MAP_SIZE / 2 - s, MAP_SIZE / 2])
	dir = [1, 0]
	spawn_food()
	state = "menu"
	if sound:
		play_sound(SND.get_freq("C", 5), 1.0 / 30.0)
		play_sound(SND.get_freq("B", 4), 1.0 / 30.0)
		play_sound(SND.get_freq("A", 4), 1.0 / 30.0)
		play_sound(SND.get_freq("G", 4), 1.0 / 30.0)
