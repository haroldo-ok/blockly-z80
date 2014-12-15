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

Blockly.Z80['hardware_sprite_tile'] = function(block) {
	var sprite_number = Blockly.Z80.valueToCode(block, 'NUMBER', Blockly.Z80.ORDER_ATOMIC) || 'ld hl, 0\n';
	var tile_number = Blockly.Z80.valueToCode(block, 'TILE_NUMBER', Blockly.Z80.ORDER_ATOMIC) || 'ld hl, 0\n';
	
	var code = [
		tile_number.trim(),
		'push hl', // Save tile number for later
		sprite_number.trim(),
		'pop de', // DE contains the tile number
		'call SetSpriteTile'
	];
	return code.join('\n') + '\n';
};

Blockly.Z80['hardware_wait_vblank'] = function(block) {
	var code = 'call WaitForVBlank\n';
	return code;
};

Blockly.Z80['hardware_read_joypads'] = function(block) {
  var code = 'call ReadJoypads\n';
  return code;
};

Blockly.Z80['hardware_read_joypad'] = function(block) {
  var which_button = block.getFieldValue('BUTTON');
  var which_joypad = block.getFieldValue('JOYPAD');

  var code = [
	'ld c, Joypad_' + which_button,
	'call ' + (which_joypad == 'JOYPAD2' ? 'ReadJoypad2' : 'ReadJoypad1')
  ];
  
  return [code.join('\n') + '\n', Blockly.Z80.ORDER_ATOMIC];
};
