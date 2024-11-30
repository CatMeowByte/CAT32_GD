extends CAT32


var snake = [[0, 0]] # Pos inside array
var dir = [1 , 0]
var food = [32, 32]
var f = 0

func init():
	restart()

func update():
	f += 1
	input()

	o(snake[0][0])
	var head = [snake[0][0] + dir[0], snake[0][1] + dir[1]]
	snake.push_front(head)
	o(snake[0][0])
	if head == food:
		o("eat")
		spawn_food()
	else:
		snake.pop_back()

	pass
	# Collision
	#if head[0] < 0 or head[1] < 0 or head[0] >= DIS.W or head[1] >= DIS.HVIEW or head in snake.duplicate().pop_front():
		#restart()

func input():
	if BTN.pressed(BTN.UP):
		dir = [0, -1]
	if BTN.pressed(BTN.DOWN):
		dir = [0, 1]
	if BTN.pressed(BTN.LEFT):
		dir = [-1, 0]
	if BTN.pressed(BTN.RIGHT):
		dir = [1, 0]

func draw():
	DIS.clear(COL.DARK_GRAY)
	DIS.pixel(food[0], food[1], COL.GREEN)
	for s in snake:
		DIS.pixel(s[0], s[1], COL.WHITE)

	DIS.text(0, 0, "snake " + str(snake), COL.LIGHT_GRAY)
	DIS.text(0, 8, "food " + str(food), COL.LIGHT_GRAY)
	DIS.text(0, DIS.HVIEW - 8, "#" if f % 2 == 0 else "-", COL.WHITE)
	DIS.text(8, DIS.HVIEW - 8, str(f), COL.WHITE)

func spawn_food():
	food = [int(random(DIS.W)), int(random(DIS.HVIEW))]
	if food in snake:
		spawn_food()

func restart():
	snake = [[DIS.W / 2, DIS.HVIEW / 2]] # Pos inside array
	dir = [1, 0]
	spawn_food()
