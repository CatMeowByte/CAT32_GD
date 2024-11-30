extends CAT32

const BODY_COUNT = 16
const FOOD_COUNT = 512

var snake = []
var dir = [1 , 0]
var food = []
var f = 0
var boost = 1
var state = "menu"
var menu_sel = 0
var menu_items = ["Play", "Options", "Exit"]
var options_sel = 0
var options_items = ["Sound", "Food Highlight"]
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
		play_sound(SND.get_freq("C", 4), 1.0 / 20.0)

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

	# Collision
	if head[0] < 0 or head[1] < 0 or head[0] >= DIS.W or head[1] >= DIS.HVIEW:
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
		play_sound(SND.get_freq("C", 4), 1.0 / 20.0)

func draw():
	if state == "menu":
		draw_menu()
	elif state == "options":
		draw_options()
	else:
		input()
		draw_game()

func draw_menu():
	DIS.clear(COL.DARK_PURPLE)
	DIS.text(8, 8, "SNAKE", COL.WHITE)
	COL.mask(COL.BLACK, 0)
	COL.mask(COL.PINK, 1)
	for i in range(menu_items.size()):
		var fg = COL.WHITE if i == menu_sel else COL.LIGHT_GRAY
		var bg = COL.BLACK if i == menu_sel else COL.PINK
		DIS.text(8, 16 + (i * 8), menu_items[i], fg, bg)
	COL.mask()

func draw_options():
	DIS.clear(COL.DARK_PURPLE)
	DIS.text(8, 8, "OPTIONS", COL.WHITE)
	COL.mask(COL.BLACK, 0)
	COL.mask(COL.PINK, 1)
	for i in range(options_items.size()):
		var fg = COL.WHITE if i == options_sel else COL.LIGHT_GRAY
		var bg = COL.BLACK if i == options_sel else COL.PINK
		var value = "ON" if (i == 0 and sound_enabled) or (i == 1 and highlight_food) else "OFF"
		DIS.text(8, 16 + (i * 8), options_items[i] + ": " + value, fg, bg)
	COL.mask()

func draw_game():
	DIS.clear(COL.DARK_BLUE)
	var flip = 1 if snake[0][0] < DIS.W / 2 or snake[0][1] < DIS.HVIEW / 2 else 0
	var score = str(snake.size() - BODY_COUNT)
	COL.mask(COL.BLACK, 0)
	DIS.text((DIS.W - 4 * score.length()) * flip, (DIS.HVIEW - 8) * flip, score, COL.WHITE, COL.BLACK)
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
		var new_food = [int(random(DIS.W)), int(random(DIS.HVIEW))]
		if new_food not in snake and new_food not in food:
			food.append(new_food)

func restart(sound = 0):
	snake = []
	for s in range(BODY_COUNT):
		snake.append([DIS.W / 2 - s, DIS.HVIEW / 2])
	dir = [1, 0]
	spawn_food()
	state = "menu"
	if sound:
		play_sound(SND.get_freq("C", 5), 1.0 / 30.0)
		play_sound(SND.get_freq("B", 4), 1.0 / 30.0)
		play_sound(SND.get_freq("A", 4), 1.0 / 30.0)
		play_sound(SND.get_freq("G", 4), 1.0 / 30.0)
