'use strict';

goog.provide('Blockly.Blocks.hardware');

goog.require('Blockly.Blocks');

// https://blockly-demo.appspot.com/static/demos/blockfactory/index.html#9if9fy
Blockly.Blocks['hardware_update_sprites'] = {
  init: function() {
    this.setHelpUrl('http://www.example.com/');
    this.setColour(65);
    this.appendDummyInput()
        .appendField("Update sprites");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setTooltip('Update the sprites; this should be called once per frame');
  }
};

// https://blockly-demo.appspot.com/static/demos/blockfactory/index.html#u969zn
Blockly.Blocks['hardware_sprite_move'] = {
  init: function() {
    this.setHelpUrl('http://www.example.com/');
    this.setColour(65);
    this.appendValueInput("NUMBER")
        .setCheck("Number")
        .appendField("Move sprite #");
    this.appendValueInput("X")
        .setCheck("Number")
        .appendField("to X");
    this.appendValueInput("Y")
        .setCheck("Number")
        .appendField("Y");
    this.setInputsInline(true);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setTooltip('Moves a certain sprite to the specified coordinates; please note that the new coordinates will only be effective after "Updade sprites" is called.');
  }
};

Blockly.Blocks['hardware_wait_vblank'] = {
  init: function() {
    this.setHelpUrl('http://www.example.com/');
    this.setColour(65);
    this.appendDummyInput()
        .appendField("Wait for VBlank");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setTooltip('Waits for VBlank; this should be called once per frame');
  }
};

// https://blockly-demo.appspot.com/static/demos/blockfactory/index.html#mbenfx
Blockly.Blocks['hardware_read_joypads'] = {
  init: function() {
    this.setHelpUrl('http://www.example.com/');
    this.setColour(65);
    this.appendDummyInput()
        .appendField("Read joypads");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setTooltip('Reads the joypads; this should be called once per frame');
  }
};

// https://blockly-demo.appspot.com/static/demos/blockfactory/index.html#yksd9i
Blockly.Blocks['hardware_read_joypad'] = {
  init: function() {
    this.setHelpUrl('http://www.example.com/');
    this.setColour(65);
    this.appendDummyInput()
        .appendField(new Blockly.FieldDropdown([["Up", "UP"], ["Down", "DOWN"], ["Left", "LEFT"], ["Right", "RIGHT"], ["Fire A", "FIREA"], ["Fire B", "FIREB"]]), "BUTTON")
        .appendField("is pressed on")
        .appendField(new Blockly.FieldDropdown([["Joypad 1", "JOYPAD1"], ["Joypad 2", "JOYPAD2"]]), "JOYPAD");
    this.setOutput(true, "Boolean");
    this.setTooltip('Returns the current state of the joypad; supposes that "Read joypads has been called"');
  }
};
