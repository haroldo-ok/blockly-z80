"use strict";

(function(){

	QUnit.module("Peephole optimizer");
	
	var testNumber = 1;
	function assertOptimizer(source, expected, description) {
		QUnit.test(description || ("Test " + testNumber), function(assert) {
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
	], "Assignment with constants");
	
	assertOptimizer([
		'  ld hl, 10',
		'  push hl',
		'  ld hl, 20',
		'  pop de',
		'  or a',
		'  ex de, hl',
		'  sbc hl, de'
	], [
		'ld de, 10',
		'ld hl, 20',
		'or a',
		'ex de, hl',
		'sbc hl, de'
	], "Optimizable code with extra spaces");
	

})();
