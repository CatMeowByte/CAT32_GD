extends CAT32

var path = "/"
var entries = []
var select = 0

func init():
	load_directory()

func load_directory():
	entries = DIR.ls_dir(path) + DIR.ls_file(path)
	select = 0

func update():
	select += int(BTN.pressed(BTN.DOWN)) - int(BTN.pressed(BTN.UP))
	select = clamp(select, 0, entries.size() - 1)

	if BTN.pressed(BTN.ACCEPT) and entries:
		if entries[select] in DIR.ls_dir(path):
			path = path.path_join(entries[select])
			load_directory()
	elif BTN.pressed(BTN.CANCEL):
		var split = Array(path.trim_prefix("/").split("/"))
		split.pop_back()
		path = "/" + "/".join(split)
		load_directory()

func draw():
	DIS.clear(COL.BLACK)
	DIS.rect(0, 0, DIS.W, 8, COL.DARK_BLUE, 1)
	DIS.text(0, 0, path, COL.BLUE)
	for i in range(entries.size()):
		var is_dir = entries[i] in DIR.ls_dir(path)
		if i == select:
			DIS.rect(0, 8 + i * 8, DIS.W, 8, COL.DARK_GRAY, 1)
			DIS.text(0, 8 + i * 8, entries[i], COL.YELLOW if is_dir else COL.WHITE)
		else:
			DIS.text(0, 8 + i * 8, entries[i], COL.PINK if is_dir else COL.LIGHT_GRAY)
