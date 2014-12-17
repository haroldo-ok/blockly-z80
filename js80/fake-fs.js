'use strict';

module.exports = {
	existsSync: function(fileName) {
		return window.JS80.fileExists(fileName);
	},
	
	readFileSync: function(fileName) {
		return window.JS80.readFile(fileName);
	}
};
