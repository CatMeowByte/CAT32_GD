extends CAT32

# Argument
var path = "/CAT32.gd"

var txt = []
var crs = [0, 0]
var scr_off = [0, 0]
var scr_max = [0, 0]
var scr_spd = 0.2

func init():
	BTN.repeat_delay = 2
	BTN.repeat_interval = 1
	# Open the file and read txt
	var file = FileAccess.open(ROOT.path_join(path), FileAccess.READ)
	txt = file.get_as_text().split("\n")
	file.close()

	# Max horizontal scroll offset (longest line length - screen width)
	for ln in txt:
		scr_max[0] = max(scr_max[0], (ln.length() + 1) * 4 - DIS.W)

	# Max vertical scroll offset (total number of txt - screen height)
	scr_max[1] = max(0, txt.size() * 8 - DIS.H)

func update():
	var dx = int(BTN.get_repeat(BTN.RIGHT)) - int(BTN.get_repeat(BTN.LEFT))
	var dy = int(BTN.get_repeat(BTN.DOWN)) - int(BTN.get_repeat(BTN.UP))

	crs[0] = clamp(crs[0] + dx, 0, txt[crs[1]].length())
	crs[1] = clamp(crs[1] + dy, 0, txt.size() - 1)

	# Target scroll position to center the crs
	var scr_tx = crs[0] * 4 - DIS.W / 2 + 2
	var scr_ty = crs[1] * 8 - DIS.H / 2 + 4

	scr_tx = clamp(scr_tx, 0, scr_max[0])
	scr_ty = clamp(scr_ty, 0, scr_max[1])

	# Lerp
	scr_off[0] += (scr_tx - scr_off[0]) * scr_spd
	scr_off[1] += (scr_ty - scr_off[1]) * scr_spd

func draw():
	DIS.clear(COL.DARK_BLUE)
	DIS.camera(scr_off[0], scr_off[1])

	DIS.rect(crs[0] * 4, crs[1] * 8, 4, 8, COL.DARK_PURPLE, 1)
	DIS.line(crs[0] * 4, crs[1] * 8, crs[0] * 4, crs[1] * 8 + 7, COL.RED)

	for i in range(txt.size()):
		var ln = txt[i]
		var fg = COL.WHITE if i == crs[1] else COL.DARK_GRAY
		DIS.text(0, i * 8, ln, fg)
