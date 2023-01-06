import utils.ChapterName;
import utils.SaveFile;

class Main {
	var dirCount = 0;
	var fileCount = 0;

	var fileArr:Array<String> = [];
	var dirArr:Array<String> = [];
	var ignoreArr:Array<String> = ['.DS_Store', '.gitkeep'];

	var startTime:Date;
	var endTime:Date;

	public function new() {
		// Sys.command('clear'); // will produce a `TERM environment variable not set.`
		info('Start project: "${Project.NAME}"');
		// check time
		startTime = Date.now();

		init();
		setupProject();
		recursiveLoop(Folder.TEXT_NL);

		info('dirCount: $dirCount', 1);
		info('fileCount: $fileCount', 1);
		info('ignoreArr: $ignoreArr', 1);

		// start convert
		updateDocs();

		// check time again
		endTime = Date.now();
		warn('Time to complete conversion: ${((endTime.getTime() - startTime.getTime()) / 1000)} sec');
	}

	function init() {
		info('init');

		Folder.ROOT_FOLDER = Sys.getCwd();
		Folder.DOCS = Path.join([Sys.getCwd(), 'docs']);
		Folder.ICONS = Path.join([Sys.getCwd(), 'design/assets/icons']);
		Folder.TEXT = Path.join([Sys.getCwd(), 'text']);
		Folder.TEXT_NL = Path.join([Sys.getCwd(), 'text/nl']);
		// Folder.BIN = Path.join([Sys.getCwd(), 'bin']);
		// Folder.DIST = Path.join([Sys.getCwd(), 'dist']);
		// Folder.ASSETS = Path.join([Sys.getCwd(), 'assets']);

		info('Folder.ROOT_FOLDER: ${Folder.ROOT_FOLDER}');
		info('Folder.DOCS: ${Folder.DOCS}');
		info('Folder.ICONS: ${Folder.ICONS}');
		info('Folder.TEXT: ${Folder.TEXT}');
		info('Folder.TEXT_NL: ${Folder.TEXT_NL}');
	}

	function setupProject() {
		wip('setupProject');
	}

	function updateDocs() {
		info('updateDocs: "${Project.NAME}"');

		var sideBarArr = [];
		var md = '<!-- docs/_sidebar.md -->\n\n';

		// get all files into docs
		for (i in 0...fileArr.length) {
			var file = fileArr[i];

			// var _ignore = false;

			// // files I will ignore for now
			// for (i in 0...ignoreArr.length) {
			// 	var ignore = ignoreArr[i];
			// 	if (Path.withoutDirectory(file) == ignore) {
			// 		_ignore = true;
			// 		continue;
			// 	}
			// }

			// if (_ignore)
			// 	continue;

			if (file.indexOf('.md') != -1) {
				mute('Docsify file: `${Path.withoutDirectory(file)}`', 1);
				sideBarArr.push(Path.withoutDirectory(file));
				Sys.command('cp ${file} ${Folder.DOCS}');
			}
		}

		// create sidebar
		md += '* [Home](/)\n';
		for (i in 0...sideBarArr.length) {
			var fileName = sideBarArr[i];
			md += '* [${ChapterName.convert(fileName)}](${fileName})\n';
		}

		SaveFile.out(Folder.DOCS + '/_sidebar.md', md);
	}

	/**
	 * [Description]
	 * @param directory
	 */
	function recursiveLoop(directory:String = "path/to/") {
		if (sys.FileSystem.exists(directory)) {
			// log("Directory found: " + directory);
			for (file in sys.FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);
				if (!sys.FileSystem.isDirectory(path)) {
					// file
					// log("File found: " + path);
					// log("File found: " + Path.withoutDirectory(path));
					fileCount++;
					fileArr.push(path);
				} else {
					// folder
					dirCount++;
					dirArr.push(path);
					var directory = haxe.io.Path.addTrailingSlash(path);
					recursiveLoop(directory);
				}
			}
		} else {
			warn('"$directory" does not exists');
		}
	}

	static public function main() {
		var app = new Main();
	}
}
