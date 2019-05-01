.SUFFIXES:

_ : parser.js
	@node main.js input.ixi output.ast > run.log

parser.js : grammar.pegjs
	@pegjs -o parser.js grammar.pegjs



