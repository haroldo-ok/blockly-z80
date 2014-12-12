"use strict";

(function(){

	QUnit.module("Peephole optimizer");
	
	var testNumber = 1;
	function assertOptimizer(source, expected) {
		QUnit.test("Test " + testNumber, function(assert) {
			var result = Blockly.Z80.optimizeSource_(source.join('\n'));
			assert.equal(result, expected.join('\n'));
		});
		testNumber++;
	}
	
	assertOptimizer([
		'ld hl, 10',
		'push hl',
		'ld hl, 20',
		'pop de',
		'or a',
		'ex de, hl',
		'sbc hl, de'
	], [
		'ld de, 10',
		'ld hl, 20',
		'or a',
		'ex de, hl',
		'sbc hl, de'
	]);
	

})();
