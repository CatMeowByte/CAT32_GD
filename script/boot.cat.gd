extends CAT32

func beep(c, t, d):
	DIS.clear(c)
	DIS.flip()
	SND.play_tone(t, d)
	await timer(d)


func init():
	await beep(COL.BLACK, 0, 0.5)
	await beep(COL.DARK_GRAY, 320.0, 0.125)
	await beep(COL.BLACK, 0, 0.0625)
	await beep(COL.DARK_GRAY, 320.0, 0.125)
	await beep(COL.BLACK, 0, 0.25)
	await beep(COL.WHITE, 880.0, 0.5)
	await beep(COL.BLACK, 0, 0.25)

	run("res://script/main.cat.gd")
