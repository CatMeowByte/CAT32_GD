extends CAT32

var path = "/"
var ls_dir = []
var ls_file = []
var entries = []
var select = 0

func init():
	load_directory()

func load_directory():
	ls_dir = DIR.ls_dir(path)
	ls_file = DIR.ls_file(path)
	entries =  ls_dir + ls_file
	select = 0

func update():
	var sp = select
	select += int(BTN.get_repeat(BTN.DOWN)) - int(BTN.get_repeat(BTN.UP))
	select = clamp(select, 0, entries.size() - 1)
	if select != sp:
		SND.play_tone(SND.get_freq("A", 4), 1.0 / 20.0)

	if BTN.get_repeat(BTN.ACCEPT) and entries:
		SND.play_tone(SND.get_freq("G", 5), 1.0 / 20.0)
		SND.play_tone(SND.get_freq("A", 6), 1.0 / 20.0)
		if entries[select] in ls_dir:
			path = path.path_join(entries[select])
			load_directory()
		elif entries[select] in ls_file:
			run(path.path_join(entries[select]))
	elif BTN.get_repeat(BTN.CANCEL):
		SND.play_tone(SND.get_freq("A", 6), 1.0 / 20.0)
		SND.play_tone(SND.get_freq("G", 5), 1.0 / 20.0)
		var split = Array(path.trim_prefix("/").split("/"))
		split.pop_back()
		path = "/" + "/".join(split)
		load_directory()

func draw():
	DIS.clear()
	DIS.rect(0, 0, DIS.W, 8, COL.DARK_BLUE, 1)
	DIS.text(0, 0, path, COL.BLUE)
	for i in range(entries.size()):
		var is_dir = entries[i] in DIR.ls_dir(path)
		if i == select:
			DIS.rect(0, 8 + i * 8, DIS.W, 8, COL.DARK_GRAY, 1)
			DIS.text(0, 8 + i * 8, entries[i], COL.YELLOW if is_dir else COL.WHITE)
		else:
			DIS.text(0, 8 + i * 8, entries[i], COL.PINK if is_dir else COL.GRAY)
