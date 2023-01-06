package scribus;

import haxe.rtti.XmlParser;

class Scribus {
	private var _xml:Xml;

	public function new() {
		info('Scribus');

		var path = Folder.ROOT_FOLDER + '/src/scribus/assets/scribus_a4.sla';
		if (sys.FileSystem.exists(path)) {
			var str:String = sys.io.File.getContent(path);
			_xml = Xml.parse(str);
		} else {
			trace('ERROR: there is not file: $path');
		}

		// _xml = Xml.createElement('SCRIBUSUTF8NEW')

		// wrap the Xml for Access
		var access = new haxe.xml.Access(_xml.firstElement());

		log(access);
		log(access.node.DOCUMENT);

		// // access the "phone" child, which is wrapped with haxe.xml.Access too
		var doc = access.node.DOCUMENT;
		// iterate over numbers
		for (c in doc.nodes.COLOR) {
			trace(c.att.SPACE);
		}
	}

	public function addColorRGB(name:String, r:Int, g:Int, b:Int) {
		var root = _xml.firstElement();
		var document = root.firstElement();
		document.addChild(Xml.parse('<COLOR SPACE="RGB" NAME="${name}"R="${r}" G="${g}" B="${b}"/>\n'));
	}

	public function addColorCMYK(name:String, c:Int, m:Int, y:Int, k:Int) {
		var root = _xml.firstElement();
		var document = root.firstElement();
		document.addChild(Xml.parse('<COLOR SPACE="CMYK" NAME="${name}" C="${c}" M="${m}" Y="${y}" K="${k}"/>\n'));
	}

	// static public function main() {
	// 	var app = new Scribus();
	// }

	public function xml():String {
		return _xml.toString();
	}
}
