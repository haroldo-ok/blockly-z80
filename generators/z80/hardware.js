'use strict';

goog.provide('Blockly.Z80.hardware');

goog.require('Blockly.Z80');

Blockly.Z80['hardware_update_sprites'] = function(block) {
	var code = 'call UpdateSprites\n';
	return code;
};

Blockly.Z80['hardware_sprite_move'] = function(block) {
	var value_number = Blockly.Z80.valueToCode(block, 'NUMBER', Blockly.Z80.ORDER_ATOMIC) || 'ld hl, 0\n';
	var value_x = Blockly.Z80.valueToCode(block, 'X', Blockly.Z80.ORDER_ATOMIC) || 'ld hl, 0\n';
	var value_y = Blockly.Z80.valueToCode(block, 'Y', Blockly.Z80.ORDER_ATOMIC) || 'ld hl, 0\n';
	// TODO: Assemble JavaScript into code variable.
	var code = [
		value_x.trim(),
		'push hl', // Save X coordinate for later
		value_y.trim(),
		'push hl', // Save Y coordinate for later
		value_number.trim(),
		'pop bc', // BC contains the Y coordinate
		'pop de', // DE contains the X cordinate
		'call MoveSpriteXY'
	];
	return code.join('\n') + '\n';
};

Blockly.Z80['hardware_wait_vblank'] = function(block) {
	var code = 'call WaitForVBlank\n';
	return code;
};
