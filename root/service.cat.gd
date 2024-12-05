extends CAT32

var time

func init():
	tick()

func tick():
	o("tick")
	DIS.camera()
	DIS.memsel(DIS.MEM_TOP)
	DIS.clear(COL.BLACK)
	DIS.text(0, 0, Time.get_time_string_from_system(), COL.WHITE)
	DIS.flip()
	DIS.memsel()
	await timer(1)
	tick()
