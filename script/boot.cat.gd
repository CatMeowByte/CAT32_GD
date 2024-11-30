extends CAT32


func beep(c, t, d):
	DIS.clear(c)
	DIS.flip()
	SND.play_tone(t, d)
	await timer(d)


func init():
	DIS.memsel(DIS.MEM_TOP)
	DIS.clear(COL.BLACK)
	DIS.text(4, 4, Time.get_time_string_from_system(), COL.DARK_GRAY)

	DIS.memsel()
	await beep(COL.BLACK, 0, 0.5)
	await beep(COL.DARK_GRAY, 320.0, 0.125)
	await beep(COL.BLACK, 0, 0.0625)
	await beep(COL.DARK_GRAY, 320.0, 0.125)
	await beep(COL.BLACK, 0, 0.25)
	await beep(COL.WHITE, 880.0, 0.5)
	await beep(COL.BLACK, 0, 0.25)

	run("res://script/snake.cat.gd")
