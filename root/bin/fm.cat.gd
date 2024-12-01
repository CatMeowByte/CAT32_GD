extends CAT32

var path = "/"
var ls = {}

func init():
	o(DIR.ls_dir(path))
	o(DIR.ls_file(path))
