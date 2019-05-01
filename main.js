#!/usr/bin/env node

var fs = require('fs');

// Slurp Input File
//
fs.readFile(process.argv[2], "utf-8", (err, code) => {
  if (err) throw err

  // `code` now contains the whole of the input file as a string

  // Parse Input
  //
  // Now we use our PEGjs parser to translate the input string to
  // a JSON structure of our own design (see grammar.pegjs). This
  // may or may not parse.
  //
  var parser = require('./parser.js')
  var ast = parser.parse(code);

  // `ast` (JSON) now contains our Abstract Syntax Tree.

  // Generate Output Code
  //
  for (let e of ast) {

    // This is not a totally functional translation to Gibber. We make assumptions.
    // We don't make proper checks. Its just a demonstration, not a working product.

    if (e.percussive) {
      let generated = `${e.agent} = Drums('${e.pattern}');`;
      console.log(generated);
    }
    if (e.melodic) {
      let l = e.pattern.split('').filter(item => item != ' ').join(',');
      let generated = `${e.agent} = FM('${e.instrument}').note.seq([${l}]);`;
      console.log(generated);
    }
    if (e.concrète) {
      let note = e.pattern.split('').filter(item => item != ' ').join(',');
      let amp = e.modifier[0].level.join(',');
      let pan = e.modifier[1].pan.join(',');
      let generated = `${e.agent} = Seq({
  note: [${note}],
  amp:  [${amp}],
  pan:  [${pan}],
  target: ${e.soundFile},
  durations: 1/4,
});`;
      console.log(generated);
    }
  }

  // Write Generated Code
  var pretty = JSON.stringify(ast, null, 2);
  fs.writeFile(process.argv[3], pretty, 'utf8', (err) => {
    if (err) throw err;
  });
});
