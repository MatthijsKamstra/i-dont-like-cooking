package utils;

class ChapterName {
	static public function convert(fileName:String):String {
		fileName = fileName.replace('.md', '').replace('_', ' ').replace('-', ' ');
		return Strings.cap(fileName);
	}
}
