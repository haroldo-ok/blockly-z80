blockly-z80
===========

Blockly adapted to generate Z80 code.

Work in progress; commands implemented so far:
- Numeric constants;
- String constants;
- Numeric printing;
- String printing;
- Getting and setting numeric variables;
- The four basic math operations (+-*/);
- Numeric comparison;
- If, elsif, endif;
- Fixed size loops.

Take a look at index.html to see what it can do: the demo provides you with a [Blockly] editor that generates Z80 assembly code in real time as it is modified; the code is shown on a side panel; the generated ASM code is also automatically assembled using [bitz80]. The generated Sega Master System ROM is fully functional can be dowloaded with a simple button click.

[Blockly]: https://github.com/google/blockly
[bitz80]: https://code.google.com/p/bitz80/
