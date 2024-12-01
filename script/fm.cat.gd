extends CAT32

var path = "/home/catmeowbyte/"
var ls = {}

func init():
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				ls[file_name] = "directory"
			else:
				ls[file_name] = "file"
				file_name = dir.get_next()
	else:
		o("An error occurred when trying to access the path.")

	o(ls)
