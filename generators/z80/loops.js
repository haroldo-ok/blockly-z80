/**
 * @license
 * Visual Blocks Language
 *
 * Copyright 2012 Google Inc.
 * https://developers.google.com/blockly/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview Generating Z80 for loop blocks.
 * @author haroldoop@gmail.com (Haroldo de Oliveira Pinheiro)
 */
'use strict';

goog.provide('Blockly.Z80.loops');

goog.require('Blockly.Z80');


Blockly.Z80['controls_repeat'] = function(block) {
	// Repeat n times (internal number).	
	var repeats = Number(block.getFieldValue('TIMES'));
	var branch = Blockly.Z80.statementToCode(block, 'DO');
  
	var code = '\t; Repeat\n' +
		'\tld bc, ' + repeats + '\n' +
		Blockly.Z80['controls_repeat'].generateBody(branch);

	return code;
};

Blockly.Z80['controls_repeat'].generateBody = function(branch) {
	var loopLabel = Blockly.Z80.variableDB_.getDistinctName('rpt_loop_', Blockly.Variables.NAME_TYPE);
	var endLoopLabel = Blockly.Z80.variableDB_.getDistinctName('rpt_loop_end_', Blockly.Variables.NAME_TYPE);
	
	var code = [
		loopLabel + ':',
		'push bc\n',
		branch,
		'pop bc',
		'dec bc',
		'ld a, b',
		'or c',
		'jr z, ' + endLoopLabel,
		'jp ' + loopLabel,
		endLoopLabel + ':'];

	return code.join('\n') + '\n';
};

Blockly.Z80['controls_repeat_ext'] = function(block) {
  // Repeat n times (external number).
  var repeats = Blockly.Z80.valueToCode(block, 'TIMES',
      Blockly.Z80.ORDER_ASSIGNMENT) || '0';
  var branch = Blockly.Z80.statementToCode(block, 'DO');
  branch = Blockly.Z80.addLoopTrap(branch, block.id);
  var code = '';
  var loopVar = Blockly.Z80.variableDB_.getDistinctName(
      'count', Blockly.Variables.NAME_TYPE);
  var endVar = repeats;
  if (!repeats.match(/^\w+$/) && !Blockly.isNumber(repeats)) {
    var endVar = Blockly.Z80.variableDB_.getDistinctName(
        'repeat_end', Blockly.Variables.NAME_TYPE);
    code += 'var ' + endVar + ' = ' + repeats + ';\n';
  }
  code += 'for (var ' + loopVar + ' = 0; ' +
      loopVar + ' < ' + endVar + '; ' +
      loopVar + '++) {\n' +
      branch + '}\n';

  return code;
};

Blockly.Z80['controls_whileUntil'] = function(block) {
  // Do while/until loop.
  var until = block.getFieldValue('MODE') == 'UNTIL';
  var argument0 = Blockly.Z80.valueToCode(block, 'BOOL',
      until ? Blockly.Z80.ORDER_LOGICAL_NOT :
      Blockly.Z80.ORDER_NONE) || 'false';
  var branch = Blockly.Z80.statementToCode(block, 'DO');
  branch = Blockly.Z80.addLoopTrap(branch, block.id);
  if (until) {
    argument0 = '!' + argument0;
  }
  return 'while (' + argument0 + ') {\n' + branch + '}\n';
};

Blockly.Z80['controls_for'] = function(block) {
  // For loop.
  var variable0 = Blockly.Z80.variableDB_.getName(
      block.getFieldValue('VAR'), Blockly.Variables.NAME_TYPE);
  var argument0 = Blockly.Z80.valueToCode(block, 'FROM',
      Blockly.Z80.ORDER_ASSIGNMENT) || '0';
  var argument1 = Blockly.Z80.valueToCode(block, 'TO',
      Blockly.Z80.ORDER_ASSIGNMENT) || '0';
  var increment = Blockly.Z80.valueToCode(block, 'BY',
      Blockly.Z80.ORDER_ASSIGNMENT) || '1';
  var branch = Blockly.Z80.statementToCode(block, 'DO');
  branch = Blockly.Z80.addLoopTrap(branch, block.id);
  var code;
  if (Blockly.isNumber(argument0) && Blockly.isNumber(argument1) &&
      Blockly.isNumber(increment)) {
    // All arguments are simple numbers.
    var up = parseFloat(argument0) <= parseFloat(argument1);
    code = 'for (' + variable0 + ' = ' + argument0 + '; ' +
        variable0 + (up ? ' <= ' : ' >= ') + argument1 + '; ' +
        variable0;
    var step = Math.abs(parseFloat(increment));
    if (step == 1) {
      code += up ? '++' : '--';
    } else {
      code += (up ? ' += ' : ' -= ') + step;
    }
    code += ') {\n' + branch + '}\n';
  } else {
    code = '';
    // Cache non-trivial values to variables to prevent repeated look-ups.
    var startVar = argument0;
    if (!argument0.match(/^\w+$/) && !Blockly.isNumber(argument0)) {
      var startVar = Blockly.Z80.variableDB_.getDistinctName(
          variable0 + '_start', Blockly.Variables.NAME_TYPE);
      code += 'var ' + startVar + ' = ' + argument0 + ';\n';
    }
    var endVar = argument1;
    if (!argument1.match(/^\w+$/) && !Blockly.isNumber(argument1)) {
      var endVar = Blockly.Z80.variableDB_.getDistinctName(
          variable0 + '_end', Blockly.Variables.NAME_TYPE);
      code += 'var ' + endVar + ' = ' + argument1 + ';\n';
    }
    // Determine loop direction at start, in case one of the bounds
    // changes during loop execution.
    var incVar = Blockly.Z80.variableDB_.getDistinctName(
        variable0 + '_inc', Blockly.Variables.NAME_TYPE);
    code += 'var ' + incVar + ' = ';
    if (Blockly.isNumber(increment)) {
      code += Math.abs(increment) + ';\n';
    } else {
      code += 'Math.abs(' + increment + ');\n';
    }
    code += 'if (' + startVar + ' > ' + endVar + ') {\n';
    code += Blockly.Z80.INDENT + incVar + ' = -' + incVar + ';\n';
    code += '}\n';
    code += 'for (' + variable0 + ' = ' + startVar + ';\n' +
        '     ' + incVar + ' >= 0 ? ' +
        variable0 + ' <= ' + endVar + ' : ' +
        variable0 + ' >= ' + endVar + ';\n' +
        '     ' + variable0 + ' += ' + incVar + ') {\n' +
        branch + '}\n';
  }
  return code;
};

Blockly.Z80['controls_forEach'] = function(block) {
  // For each loop.
  var variable0 = Blockly.Z80.variableDB_.getName(
      block.getFieldValue('VAR'), Blockly.Variables.NAME_TYPE);
  var argument0 = Blockly.Z80.valueToCode(block, 'LIST',
      Blockly.Z80.ORDER_ASSIGNMENT) || '[]';
  var branch = Blockly.Z80.statementToCode(block, 'DO');
  branch = Blockly.Z80.addLoopTrap(branch, block.id);
  var indexVar = Blockly.Z80.variableDB_.getDistinctName(
      variable0 + '_index', Blockly.Variables.NAME_TYPE);
  branch = Blockly.Z80.INDENT + variable0 + ' = ' +
      argument0 + '[' + indexVar + '];\n' + branch;
  var code = 'for (var ' + indexVar + ' in ' + argument0 + ') {\n' +
      branch + '}\n';
  return code;
};

Blockly.Z80['controls_flow_statements'] = function(block) {
  // Flow statements: continue, break.
  switch (block.getFieldValue('FLOW')) {
    case 'BREAK':
      return 'break;\n';
    case 'CONTINUE':
      return 'continue;\n';
  }
  throw 'Unknown flow statement.';
};
