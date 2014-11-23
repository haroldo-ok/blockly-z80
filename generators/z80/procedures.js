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
 * @fileoverview Generating Z80 for procedure blocks.
 * @author haroldoop@gmail.com (Haroldo de Oliveira Pinheiro)
 */
'use strict';

goog.provide('Blockly.Z80.procedures');

goog.require('Blockly.Z80');


Blockly.Z80['procedures_defreturn'] = function(block) {
  // Define a procedure with a return value.
  var funcName = Blockly.Z80.variableDB_.getName(
      block.getFieldValue('NAME'), Blockly.Procedures.NAME_TYPE);
  var branch = Blockly.Z80.statementToCode(block, 'STACK');
  if (Blockly.Z80.STATEMENT_PREFIX) {
    branch = Blockly.Z80.prefixLines(
        Blockly.Z80.STATEMENT_PREFIX.replace(/%1/g,
        '\'' + block.id + '\''), Blockly.Z80.INDENT) + branch;
  }
  if (Blockly.Z80.INFINITE_LOOP_TRAP) {
    branch = Blockly.Z80.INFINITE_LOOP_TRAP.replace(/%1/g,
        '\'' + block.id + '\'') + branch;
  }
  var returnValue = Blockly.Z80.valueToCode(block, 'RETURN',
      Blockly.Z80.ORDER_NONE) || '';
  if (returnValue) {
    returnValue = '  return ' + returnValue + ';\n';
  }
  var args = [];
  for (var x = 0; x < block.arguments_.length; x++) {
    args[x] = Blockly.Z80.variableDB_.getName(block.arguments_[x],
        Blockly.Variables.NAME_TYPE);
  }
  var code = 'function ' + funcName + '(' + args.join(', ') + ') {\n' +
      branch + returnValue + '}';
  code = Blockly.Z80.scrub_(block, code);
  Blockly.Z80.definitions_[funcName] = code;
  return null;
};

// Defining a procedure without a return value uses the same generator as
// a procedure with a return value.
Blockly.Z80['procedures_defnoreturn'] =
    Blockly.Z80['procedures_defreturn'];

Blockly.Z80['procedures_callreturn'] = function(block) {
  // Call a procedure with a return value.
  var funcName = Blockly.Z80.variableDB_.getName(
      block.getFieldValue('NAME'), Blockly.Procedures.NAME_TYPE);
  var args = [];
  for (var x = 0; x < block.arguments_.length; x++) {
    args[x] = Blockly.Z80.valueToCode(block, 'ARG' + x,
        Blockly.Z80.ORDER_COMMA) || 'null';
  }
  var code = funcName + '(' + args.join(', ') + ')';
  return [code, Blockly.Z80.ORDER_FUNCTION_CALL];
};

Blockly.Z80['procedures_callnoreturn'] = function(block) {
  // Call a procedure with no return value.
  var funcName = Blockly.Z80.variableDB_.getName(
      block.getFieldValue('NAME'), Blockly.Procedures.NAME_TYPE);
  var args = [];
  for (var x = 0; x < block.arguments_.length; x++) {
    args[x] = Blockly.Z80.valueToCode(block, 'ARG' + x,
        Blockly.Z80.ORDER_COMMA) || 'null';
  }
  var code = funcName + '(' + args.join(', ') + ');\n';
  return code;
};

Blockly.Z80['procedures_ifreturn'] = function(block) {
  // Conditionally return value from a procedure.
  var condition = Blockly.Z80.valueToCode(block, 'CONDITION',
      Blockly.Z80.ORDER_NONE) || 'false';
  var code = 'if (' + condition + ') {\n';
  if (block.hasReturnValue_) {
    var value = Blockly.Z80.valueToCode(block, 'VALUE',
        Blockly.Z80.ORDER_NONE) || 'null';
    code += '  return ' + value + ';\n';
  } else {
    code += '  return;\n';
  }
  code += '}\n';
  return code;
};
