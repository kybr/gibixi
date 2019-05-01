// IxILang Parser
// Karl Yerkes, 2019
// MAT 240A
//


// Place helper functions in a {} block here:
//
{
  function clean(p) {
    let list = [];
    for (let e of p.split('')) {
      if (e == ' ') continue;
      list.push(parseInt(e));
    }
    return list;
  }
}

// XXX This is not a perfect, exactly-the-right-way example of PEGjs or IxILang parsing
// but it works okay for subset of the syntax
//

Top
  = Statement*

Statement
  = AgentAssignment
  / EmptyLine

EmptyLine
  = _ '\n' {return 'empty line'}
  
AgentAssignment
  = a:Identifier RightArrow '|' p:PatternPipe '|' m:(Modifier*) '\n'? { return {'percussive':true, 'agent':a, 'pattern':p, 'modifier':m}; } 
  / a:Identifier RightArrow i:Identifier '[' p:SpaceNumber ']' m:(Modifier*) '\n'? { return {'melodic':true, 'agent':a, 'instrument':i, 'pattern':p, 'modifier':m}; }
  / a:Identifier RightArrow i:Identifier '{' p:SpaceNumber '}' m:(Modifier*) '\n'? { return {'concrète':true, 'agent':a, 'soundFile':i, 'pattern':p, 'modifier':m}; }

Identifier
  = _ [a-zA-Z_][0-9a-zA-Z_]* _ { return text().trim(); }

PatternPipe
  = [^|]+ { return text(); }

Modifier
  = t:LevelBlock
  / t:PanBlock
  / t:DurationBlock

LevelBlock
  = _ '^' pattern:SpaceNumber '^' _ { return {'level': clean(pattern)} }

PanBlock
  = _ '<' pattern:SpaceNumber '>' _ { return {'pan': clean(pattern)} }

DurationBlock
  = _ '(' pattern:SpaceNumber ')' _ { return {'duration': clean(pattern)} }

SpaceNumber
  = [ 0-9]+ { return text(); }

RightArrow
  = _ '->' _

_ "whitespace"
  = [ \t]*
