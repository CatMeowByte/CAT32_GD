# STORAGE
extends RefCounted

# Dependency
static var ROOT

static var _crawler: DirAccess

func ls_dir(path: String, hidden: bool = false) -> PackedStringArray:
	_crawler.set_include_hidden(hidden)
	_crawler.change_dir(ROOT.path_join(path))
	return _crawler.get_directories()

func ls_file(path: String, hidden: bool = false) -> PackedStringArray:
	_crawler.set_include_hidden(hidden)
	_crawler.change_dir(ROOT.path_join(path))
	return _crawler.get_files()
