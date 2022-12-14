import scribus.Scribus;
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
		// update the docs, perhaps for later use
		updateDocs();
		// create Scibus document, with adjustments
		createScribus();
		// create a4 document with fonts embedding (.svg and .pdf)
		createFontFile();
		// analyze the receipts
		analyzeReceipts();

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
		Folder.BIN = Path.join([Sys.getCwd(), 'bin']);
		// Folder.DIST = Path.join([Sys.getCwd(), 'dist']);
		// Folder.ASSETS = Path.join([Sys.getCwd(), 'assets']);

		info('Folder.ROOT_FOLDER: ${Folder.ROOT_FOLDER}');
		info('Folder.DOCS: ${Folder.DOCS}');
		info('Folder.ICONS: ${Folder.ICONS}');
		info('Folder.TEXT: ${Folder.TEXT}');
		info('Folder.TEXT_NL: ${Folder.TEXT_NL}');
		info('Folder.BIN: ${Folder.BIN}');
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

	function createScribus() {
		wip('createScribus');

		var type = 'a4';
		var scribus = new Scribus();

		scribus.addColorRGB('test_mck_rgb', 0, 10, 20);
		scribus.addColorCMYK('test_mck_cmyk', 0, 10, 20, 30);

		SaveFile.out(Folder.BIN + '/_gen_scribus_${type}.sla', scribus.xml());
	}

	function createFontFile() {
		wip('createFontFile');
	}

	function analyzeReceipts() {
		wip('analyzeReceipts();');

		// get all files into docs
		for (i in 0...fileArr.length) {
			var file = fileArr[i];

			// check if file is .md file
			if (file.indexOf('.md') == -1)
				continue;

			// create folders
			var path = Path.withoutExtension(file).split(Folder.ROOT_FOLDER)[1];
			var f = '${Folder.BIN}/${path}';
			Sys.command('mkdir -p ${f}');
			// warn(path);

			// read the file
			var content = sys.io.File.getContent(file);
			var linesArr = content.split('\n');
			// warn(linesArr.length);

			// strip data from file
			var _misc = '';
			var _utensils = '';
			var _ingredients = '';
			var _preparation = '';
			var _tips = '';

			var temp = ReceiptType.Misc;
			for (i in 0...linesArr.length) {
				var line = linesArr[i];

				// log(line);
				// log(line.toLowerCase().contains('gerei'));

				if (line.toLowerCase().contains('## keuken'))
					temp = ReceiptType.Utensils;
				if (line.toLowerCase().contains('## ingredi'))
					temp = ReceiptType.Ingredients;
				if (line.toLowerCase().contains('## bereidings'))
					temp = ReceiptType.Preparation;
				if (line.toLowerCase().contains('## tip'))
					temp = ReceiptType.Tips;

				switch (temp) {
					case ReceiptType.Misc:
						_misc += '${line}\n';
					case ReceiptType.Utensils:
						_utensils += '${line}\n';
					case ReceiptType.Ingredients:
						_ingredients += '${line}\n';
					case ReceiptType.Preparation:
						_preparation += '${line}\n';
					case ReceiptType.Tips:
						_tips += '${line}\n';
					default:
						trace("case '" + temp + "': trace ('" + temp + "');");
				}
			}

			extractIngredients(_ingredients, f);

			// save content
			SaveFile.out(f + '/misc.md', _misc.trim());
			SaveFile.out(f + '/utensils.md', _utensils.trim());
			SaveFile.out(f + '/ingredients.md', _ingredients.trim());
			SaveFile.out(f + '/preparation.md', _preparation.trim());
			SaveFile.out(f + '/tips.md', _tips.trim());
		}
	}

	function extractIngredients(str:String, path:String) {
		info('extractIngredients');

		var md = '# Buy ingredients at Jumbo.com\n\n';
		var stripArr = [
			//
			'- ',
			',',
			'in blokjes',
			'in dunne plakjes',
			'uitgelekt',
			'teentje',
			'fijngehakt',
			'500',
			'250',
			'2',
			'6',
			'1',
			'gram',
			'blikje',
			'bakje',
			'theelepel'
		];
		var lineArr = str.split('\n');

		for (i in 0...lineArr.length) {
			var line = lineArr[i];
			var original = line.replace('- ', '');
			if (line.trim() == '') {
				continue;
			}
			if (line.indexOf('## ') != -1) {
				continue;
			}

			for (i in 0...stripArr.length) {
				var strip = stripArr[i];
				line = line.replace(strip, '');
			}

			// md += '${line.trim().replace(' ', '%20')}\n';
			md += '- [${original.trim()}](https://www.jumbo.com/producten/?searchType=keyword&searchTerms=${line.trim().replace(' ', '%20')}&offSet=0&sort=price%20asc)\n';
		}

		SaveFile.out(path + '/_buy.md', md);
	}

	/**
	 * [Description]
	 * @param directory
	 */
	function recursiveLoop(directory:String) {
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

enum ReceiptType {
	Misc;
	Utensils;
	Ingredients;
	Preparation;
	Tips;
}
