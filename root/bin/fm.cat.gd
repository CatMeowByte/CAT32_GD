extends CAT32

var path = "/home/catmeowbyte/"
var ls = {}

func init():
	o(DirAccess.get_files_at(path))
