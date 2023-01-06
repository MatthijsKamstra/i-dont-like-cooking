package utils;

import haxe.io.Path;

using StringTools;

class SaveFile {
	static public function out(path:String, str:String) {
		info('Write file to path:"${path.split(Folder.ROOT_FOLDER)[1]}"');
		// write the file
		sys.io.File.saveContent(path, str);
	}
}
