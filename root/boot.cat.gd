extends CAT32

const DELAY = 0.03125
const FREQ_STEP = 1.12246
const COLOR_COUNT = 16

var current_freq = 440.0
var stripe_height = DIS.H / COLOR_COUNT

func init():
	cls()
	for i in range(COLOR_COUNT):
		var y = i * stripe_height
		rect(0, y, DIS.W, stripe_height, i, true)
		flip()
		SND.play_tone(current_freq, DELAY, true)
		current_freq *= FREQ_STEP
		await timer(DELAY)

	await timer(DELAY * 16)
	cls()
	flip()
	SND.play_tone(SND.get_freq("C", 4), DELAY)
	await timer(DELAY * 8)
	text(0, 0 , "███ ███ ███     ███ ███", COL.WHITE)
	text(0, 8 , "█   █ █  █        █   █", COL.WHITE)
	text(0, 16, "█   ███  █  ███  ██   █", COL.WHITE)
	text(0, 24, "█   █ █  █        █  █ ", COL.WHITE)
	text(0, 32, "███ █ █  █      ███ ███", COL.WHITE)
	text(0, 40, "CAT-32-GD", COL.WHITE)
	flip()
	SND.play_tone(SND.get_freq("D", 5), DELAY)
	await timer(DELAY * 2)
	text(0, DIS.H - 8, "0.0.0 Experimental", COL.DARK_GRAY)
	flip()
	SND.play_tone(SND.get_freq("G", 5), DELAY)
	await timer(DELAY * 32)

	exit()
	#exec("/bin/hi.cat.gd", {"uname" = "/bin/cat.cat.gd"})
