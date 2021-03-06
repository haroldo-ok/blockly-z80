$.when.apply(this, ['data.asm', 'sms.asm', 'coleco.asm', 'sg-1000.asm', 'common.asm'].map(function(fileName){
	return $.ajax(fileName, { dataType: 'text' })
		.then(function(text){
			this.returnInfo = {
				fileName: fileName,
				text: text
			};
		});
})).then(
	function(){
		console.log('ASM includes loaded.');
		window.assemblyIncludes = this.reduce(function(o, ret){
			o[ret.returnInfo.fileName] = ret.returnInfo.text;
			return o;
		}, {});
		checkLoaded();
	},
	function(jqXHR, textStatus, errorThrown){
		console.error(errorThrown);
		alert('Failed loading one of the asm includes. ROM generation may not work.');
	}
);

function blocklyLoaded(blockly) {		
	// Called once Blockly is fully loaded.
	console.debug('Blockly ready');			
	window.Blockly = blockly;
	checkLoaded();
}

function bitz80Loaded(BitZ80) {
	console.debug('BitZ80 ready');			
	window.BitZ80 = BitZ80;
	
	BitZ80.ASM.fExternalLoader = function(fileName) {
		if (fileName == 'hardware.asm') {
			var mapping = {
				'sms': 'sms.asm',
				'sg': 'sg-1000.asm'
			};
			fileName = mapping[$('#hardware-type').val()];
			return assemblyIncludes[fileName] + '\n\n' + assemblyIncludes['common.asm'];
		}				
		return assemblyIncludes[fileName];
	}
	
	// Patches the include directive to actually add the included things
	BitZ80.ASM.prototype.originalMatchDirective = BitZ80.ASM.prototype.matchDirective;
	BitZ80.ASM.prototype.matchDirective = function(sOp, sParams) {
		if (!this.sStruct && sOp == 'INCLUDE') {
			var sFile = eval(this.prepareParam(sParams));
			var sCode = BitZ80.ASM.fExternalLoader(sFile);
			var oASM = new BitZ80.ASM();
			oASM.aMem = this.aMem;
			oASM.aData = this.aData;
			oASM.aLabels = this.aLabels;
			oASM.iPointer = this.iPointer;
			oASM.iBegin = this.iBegin;
			oASM.iExec = this.iExec;
			oASM.aTime = this.aTime;
			oASM.iM1 = this.iM1;
			oASM.sLastLabel = this.sLastLabel;
			oASM.sGenType = this.sGenType;
			
			//this.fBreakpoint = null;
			//this.aBreakpoints = null;
			//this.sGenType = 'bin';
			oASM.oParentASM = this;
			oASM.start(sCode);
			
			this.iPointer = oASM.iPointer;
			this.iBegin = oASM.iBegin;
			this.iM1 = oASM.iM1;
			this.sLastLabel = oASM.sLastLabel;
			this.aMem = this.aMem.concat(oASM.aMem);
			
			return true;
		} else {
			return this.originalMatchDirective(sOp, sParams);
		}
	}
	
	checkLoaded();
}

function checkLoaded() {
	if (window['Blockly'] && window['BitZ80'] && window['assemblyIncludes']) {
		console.debug('Everything is ready');
		
		BitZ80.compile = function(){
			var code = Blockly.Z80.workspaceToCode();
			
			var pre = $('#blockly-output').html('<pre>').find('> pre').addClass('language-z80asm');
			pre.html(code);
			Prism.highlightElement(pre[0])
			
			var bzOut = document.getElementById('bitz80-output');
			bzOut.value = '';
			
			var asm = new BitZ80.ASM();
			BitZ80.code = null;
			
			try {
				asm.start(code);
				asm.evaluateData();
				asm.patch();
			
				BitZ80.code = asm.aMem;
				BitZ80.labels = asm.aLabels;
				
				bzOut.value = 'OK';
			} catch (e) {
				bzOut.value = e;
			}
		}

		// Capture Blockly's change event.
		Blockly.addChangeListener(BitZ80.compile);
		
		// Capture 'Target Hardware' select
		$('#hardware-type').change(BitZ80.compile);
		
		// Capture 'Save ROM' button click
		document.getElementById('save-rom').addEventListener('click', function(){
			var bytes = new Uint8Array(BitZ80.code)
			var blob = new Blob([bytes], {type: "application/octet-stream"});
			var ext = $('#hardware-type').val();
			saveAs(blob, 'bitz80.' + ext);
		});
		
		// Page finished loading
		$('body').removeClass('loading');
	} else {
		// Still waiting for dependencies to load
	}			
}


$(function(){
	$("#blockly-editor").attr("src", "blockly-frame.html");
	$("#bitz80-container").attr("src", "bitz80-frame.html");

	var BLOCKLY_DESIGN_XML_FILENAME = "blockly-design.xml";
	zip.useWebWorkers = false;
	$("#save-design").click(function(){
		var dom = Blockly.Xml.workspaceToDom(Blockly.mainWorkspace);
		var xmlContent = Blockly.Xml.domToPrettyText(dom);
		
		zip.createWriter(new zip.BlobWriter(), function(writer) {
			writer.add(BLOCKLY_DESIGN_XML_FILENAME, new zip.TextReader(xmlContent), function() {
				writer.close(function(blob) {
					saveAs(blob, 'blockly-design.zip');
				});
			}, function(currentIndex, totalIndex) {
				// onprogress callback
			});
		}, function(error) {
			console.error(error);
		});
	});
	
	var designSelector = $("#design-file-input");
	$("#load-design").click(function(){ designSelector.click(); });
	designSelector.change(function(){
		console.log(this.files);
		
		zip.createReader(new zip.BlobReader(this.files[0]), function(reader) {
		
			reader.getEntries(function(entries) {
				var entry = _.find(entries, function(en){ return en.filename == BLOCKLY_DESIGN_XML_FILENAME });
				if (!entry) {
					throw new Error('File not found on zip: ' + BLOCKLY_DESIGN_XML_FILENAME);
				}
				
				entry.getData(new zip.TextWriter(), function(text) {
					console.info("Loading:\n" + text);
					var dom = Blockly.Xml.textToDom(text);
					
					Blockly.mainWorkspace.clear();
					Blockly.Xml.domToWorkspace(Blockly.mainWorkspace, dom);
				}, function(current, total) {
					// onprogress callback
				});
			});
		}, function(error) {
			console.error(error);
			doneLoading();
		});
	});
});
