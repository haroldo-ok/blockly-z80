/**
 * Z80 ASM syntax highlighter for Prism
 * Language: Z80 Assembly
 * Author: Haroldo de Oliveira Pinheiro <haroldoop@gmail.com>
 */
Prism.languages.z80asm = {
	'comment': [
		{
			pattern: /(^|[^\\])\/\*[\w\W]*?\*\//g,
			lookbehind: true
		},
		{
			pattern: /(^|[^\\:]);.*?(\r?\n|$)/g,
			lookbehind: true
		}
	],
	'string': /("|')(\\?.)*?\1/g,
	'keyword': /\b(ld|ex|exx|add|adc|sub|sbc|di|ei|im|nop|hlt|inc|dec|daa|cpl|scf|ccf|neg|rlca|rrca|rla|rra|rld|rrd|rlc|rl|rrc|and|xor|or|cp|cpi|cpir|cpd|cpdr|jp|jr|djnz|call|ret|reti|retn|rst|push|pop|in|ini|inir|ind|indr|out|outi|otir|outd|otdr|ldi|ldir|ldd|lddr|bit|res|set|sla|sra|srl)\b/g,
	'attr-value': /\b(a|b|c|d|e|f|r|h|l|af|hl|bc|de|ix|iy|z|nz|nc|po|pe|p|m)\b/g,
	'boolean': /\b(true|false)\b/g,
	'function': /\b(org|include|equ|db|dw|ds)\b/g,
	'number': /\b-?(0x[\dA-Fa-f]+|\d*\.?\d+([Ee]-?\d+)?)\b/g,
	'operator': /[-+]{1,2}|!|<=?|>=?|={1,3}|&{1,2}|\|?\||\?|\*|\/|\~|\^|\%/g,
	'ignore': /&(lt|gt|amp);/gi,
	'punctuation': /[{}[\];(),.:]/g,
	'identifier' : /\b(\w+)\b/g
};
