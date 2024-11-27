ENTRY {title}{}{}

INTEGERS {
  lowercase.word.after.colon
  % token.state
  % inter.token.state
}

STRINGS { current.test }

STRINGS { s t }

INTEGERS { a b }

FUNCTION {default.self.tokens} { ":-,.!?'" }

FUNCTION {latin.upper} { "ÀÁÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸĀĂĄĆĈĊČĎĐĒĔĖĘĚĜĞĠĢĤĦĨĪĬĮİIĴĶĹĻĽĿŁŃŅŇŊŌŎŐŒŔŖŘŚŜŞŠŢŤŦŨŪŬŮŰŲŴŶŸŹŻŽ" }

FUNCTION {latin.lower} { "àáãäåæçèéêëìíîïðñòóôõöøùúûüýþÿāăąćĉċčďđēĕėęěĝğġģĥħĩīĭįiıĵķĺļľŀłńņňŋōŏőœŕŗřśŝşšţťŧũūŭůűųŵŷÿźżž" }

FUNCTION {utf8.bytes} { "¿þĽżƻǺȹɸʷ˶̵ʹγϲбѰүӮԭլ֫תة٨ڧۦܥݤޣߢáàßÞÝÜÛÚÙØ×ÖÕÔÓÒÑÐÏÎÍÌËÊÉÈÇÆÅÄÃÂÁÀက 　䀀倀怀瀀耀退ꀀ뀀쀀퀀𐀀񐀀򐀀󐀀􀀀" }

FUNCTION {utf8.collation} { "" }

FUNCTION {range.separators} { "-–—~～" }

FUNCTION {not}
{
    { #0 }
    { #1 }
  if$
}

FUNCTION {or}
{
    { pop$ #1 }
    'skip$
  if$
}

FUNCTION {and}
{
    'skip$
    { pop$ #0 }
  if$
}

% int, int, int -> bool
% variable used: b
FUNCTION {is.int.in.range}
{
  'b :=
  #1 +
  b >
    { #1 - b < }
    { pop$ #0 }
  if$
}

% int, int -> int
FUNCTION {mult.power2}
{
  { duplicate$ #0 > }
    {
      swap$
      duplicate$ +
      swap$ #1 -
    }
  while$
  pop$
}

% int, int -> remainder: int, quotient: int
% variables used: a, b
FUNCTION {div.power2}
{
  #0 'a :=
  #1 swap$ mult.power2 'b :=
  { duplicate$ b #1 - > }
    {
      b -
      a #1 + 'a :=
    }
  while$
  a
}

% "{", str -> subtoken: str, rest: str
% variables used: s, t
FUNCTION {find.match.brace}
{
  's :=
  't :=

  #1
  { duplicate$ #0 >
    s empty$ not and }
    {
      s #1 #1 substring$ "{" =
        { #1 + }
        {
          s #1 #1 substring$ "}" =
            { #1 - }
            'skip$
          if$
        }
      if$
      t s #1 #1 substring$ * 't :=
      s #2 global.max$ substring$ 's :=
    }
  while$

  duplicate$ #0 >
    {
      "Unbalanced brace(s): one or more closing braces are missing" warning$
      { duplicate$ #0 > }
        {
          t "}" * 't :=
          #1 -
        }
      while$
    }
    'skip$
  if$
  pop$

  t
  s
}

% str -> str, char
FUNCTION {split.first.char.from.str}
{
  duplicate$ "" =
    {
      "split.first.char.from.str: Trying to split an empty string!" warning$
      ""
    }
    {
      duplicate$ #1 #1 substring$ chr.to.int$ #128 <
        {
          duplicate$ #1 #1 substring$ swap$
          #2 global.max$ substring$ swap$
        }
        {
          duplicate$ #1 #1 substring$ chr.to.int$ #224 <
            {
              duplicate$ #1 #2 substring$ swap$
              #3 global.max$ substring$ swap$
            }
            {
              duplicate$ #1 #1 substring$ chr.to.int$ #240 <
                {
                  duplicate$ #1 #3 substring$ swap$
                  #4 global.max$ substring$ swap$
                }
                {
                  duplicate$ #1 #4 substring$ swap$
                  #5 global.max$ substring$ swap$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
}

% str -> char
FUNCTION {get.first.char.from.str}
{
  split.first.char.from.str swap$ pop$
}

% str -> rest: str, texchar
FUNCTION {split.first.tex.char.from.str}
{
  duplicate$ #1 #2 substring$ "{" #92 int.to.chr$ * =
    {
      split.first.char.from.str swap$
      find.match.brace swap$
    }
    'split.first.char.from.str
  if$
}

% str -> int
FUNCTION {count.chars}
{
  #0 swap$
  { duplicate$ "" = not }
    {
      split.first.char.from.str pop$
      swap$ #1 + swap$
    }
  while$
  pop$
}

% char -> int
FUNCTION {char.to.unicode}
{
  duplicate$ #4 #1 substring$ "" =
    {
      duplicate$ #3 #1 substring$ "" =
        {
          duplicate$ #2 #1 substring$ "" =
            {
              duplicate$ "" =
                {
                  "Empty string is not a char!" warning$
                  pop$ #-1
                }
                { #1 #1 substring$ chr.to.int$ }
              if$
            }
            {
              duplicate$ #2 #1 substring$ chr.to.int$ #128 - swap$
              #1 #1 substring$ chr.to.int$ #192 -
              #6 mult.power2 +
            }
          if$
        }
        {
          duplicate$ #3 #1 substring$ chr.to.int$ #128 - swap$
          duplicate$ #2 #1 substring$ chr.to.int$ #128 - swap$
          #1 #1 substring$ chr.to.int$ #224 -
          #6 mult.power2 +
          #6 mult.power2 +
        }
      if$
    }
    {
      duplicate$ #4 #1 substring$ chr.to.int$ #128 - swap$
      duplicate$ #3 #1 substring$ chr.to.int$ #128 - swap$
      duplicate$ #2 #1 substring$ chr.to.int$ #128 - swap$
      #1 #1 substring$ chr.to.int$ #240 -
      #6 mult.power2 +
      #6 mult.power2 +
      #6 mult.power2 +
    }
  if$
}

% str, char -> bool
% variable used: t
FUNCTION {is.char.in.str}
{
  't :=

  t "" =
    { "is.char.in.str: Empty string is not a char!" warning$ }
    'skip$
  if$

  #0 swap$
  { duplicate$ "" = not }
    {
      split.first.char.from.str t =
        { pop$ pop$ #1 "" }
        'skip$
      if$
    }
  while$
  pop$
}

% char -> bool
% variable used: b
FUNCTION {is.digit}
{
  char.to.unicode #48 #57 is.int.in.range
}

% char -> bool
% variable used: b
FUNCTION {is.upper.ascii}
{
  char.to.unicode #65 swap$ #90 swap$ is.int.in.range
}

% char -> bool
% variable used: b
FUNCTION {is.upper}
{
  duplicate$ is.upper.ascii
    { pop$ #1 }
    { latin.upper swap$ is.char.in.str }
  if$
}

% str -> bool
% variable used: b
% return true if str is empty
FUNCTION {is.all.upper}
{
  #1 swap$
  purify$
  { duplicate$ "" = not }
    {
      split.first.char.from.str is.upper
        'skip$
        { pop$ pop$ #0 "" }
      if$
    }
  while$
  pop$
}

% char -> bool
% variable used: b
FUNCTION {is.lower.ascii}
{
  char.to.unicode #97 swap$ #122 swap$ is.int.in.range
}

% char -> bool
% variable used: b
FUNCTION {is.lower}
{
  duplicate$ is.lower.ascii
    { pop$ #1 }
    { latin.lower swap$ is.char.in.str }
  if$
}

% char -> bool
% variable used: b
FUNCTION {is.printable.ascii}
{
  char.to.unicode #32 swap$ #126 swap$ is.int.in.range
}

% char -> bool
% variable used: b
FUNCTION {is.letter.ascii}
{
  duplicate$ is.upper.ascii swap$ is.lower.ascii or
}

% char -> bool
% variable used: b
FUNCTION {is.symbol.ascii}
{
  duplicate$ is.printable.ascii swap$ is.letter.ascii not and
}

% str -> bool
% variable used: b
% return true if str is empty
FUNCTION {is.all.lower}
{
  #1 swap$
  purify$
  { duplicate$ "" = not }
    {
      split.first.char.from.str is.lower
        'skip$
        { pop$ pop$ #0 "" }
      if$
    }
  while$
  pop$
}

% str -> bool
% variable used: b
FUNCTION {is.in.title.case}
{
  purify$
  duplicate$ "" =
    { pop$ #0 }
    {
      split.first.char.from.str is.upper
        {
          duplicate$ "" =
            { pop$ #0 }
            'is.all.lower
          if$
        }
        { pop$ #0 }
      if$
    }
  if$
}

% char, int -> bool
% variables used: t, b
FUNCTION {is.in.inter.token.chars}
{
  duplicate$ #0 =
    { pop$ " " = }
    {
      #1 =
        { range.separators swap$ is.char.in.str }
        'is.letter.ascii
      if$
    }
  if$
}

% str, int -> intertoken: str, rest: str
% variable used: t, b
FUNCTION {skip.inter.token.chars.by}
{
  'b :=
  't :=

  "" t
  { duplicate$ "" = not }
    {
      split.first.char.from.str
      duplicate$ b is.in.inter.token.chars
        { swap$ 't := * t }
        { swap$ * 't := "" }
      if$
    }
  while$

  pop$ t
}

% str -> intertoken: str, rest: str
% variable used: t, b
FUNCTION {skip.inter.token.chars}
{
  #0 skip.inter.token.chars.by
}

% str -> intertoken: str, rest: str
% variable used: t, b
FUNCTION {skip.inter.token.command}
{
  duplicate$ "" =
    { "" }
    {
      duplicate$ #1 #1 substring$ is.symbol.ascii
        { split.first.char.from.str swap$ }
        { #2 skip.inter.token.chars.by }
     if$
    }
  if$
}

% str, str, char -> char
% variable used: t
FUNCTION {map.char}
{
  't :=
  split.first.char.from.str
  { swap$ duplicate$ "" = not }
    {
      swap$ t =
        { pop$ "" t }
        {
          swap$ split.first.char.from.str pop$ swap$
          split.first.char.from.str
        }
      if$
    }
  while$
  pop$ t =
    'get.first.char.from.str
    { pop$ t }
  if$
}

% char -> char
% variables used: t, b
FUNCTION {to.lower}
{
  duplicate$ is.upper.ascii
    { chr.to.int$ #32 + int.to.chr$ }
    { latin.lower swap$ latin.upper swap$ map.char }
  if$
}

% char -> char
% variables used: t, b
FUNCTION {to.upper}
{
  duplicate$ is.lower.ascii
    { chr.to.int$ #32 - int.to.chr$ }
    { latin.upper swap$ latin.lower swap$ map.char }
  if$
}

% str -> str
% variables used: t, b
FUNCTION {all.to.lower}
{
  "" swap$
  { duplicate$ empty$ not }
    { split.first.char.from.str to.lower swap$ 't := * t }
  while$
  *
}

% texchar -> str
% variables used: t, b
FUNCTION {tex.to.lower}
{
  "" swap$
  { duplicate$ "" = not }
    {
      split.first.char.from.str
      duplicate$ #92 int.to.chr$ =
        { swap$ skip.inter.token.command 't := * t }
        { to.lower swap$ }
      if$
      't := * t
    }
  while$
  pop$
}

% str -> str
% variables used: t, b
FUNCTION {all.to.upper}
{
  "" swap$
  { duplicate$ empty$ not }
    { split.first.char.from.str to.upper swap$ 't := * t }
  while$
  *
}

% texchar -> str
% variables used: t, b
FUNCTION {tex.to.upper}
{
  "" swap$
  { duplicate$ "" = not }
    {
      split.first.char.from.str
      duplicate$ #92 int.to.chr$ =
        { swap$ skip.inter.token.command 't := * t }
        { to.upper swap$ }
      if$
      't := * t
    }
  while$
  pop$
}

% str -> str
% variables used: b
FUNCTION {all.to.upper.bak}
{
  t swap$ s swap$
  "" swap$
  { duplicate$ empty$ not }
    { split.first.char.from.str
      duplicate$ "{" =
        { swap$ find.match.brace }
        { to.upper swap$ }
      if$
      't := * t }
  while$
  *
  swap$ 's :=
  swap$ 't :=
}

% str -> str
% variable used: t, b
FUNCTION {lower.token.if.in.title.case}
{
  duplicate$ is.in.title.case
    { split.first.tex.char.from.str tex.to.lower swap$ * }
    'skip$
  if$
}

% int -> byte
% constant used: utf8.bytes
FUNCTION {int.to.byte.prefix10}
{
  #64 swap$ - duplicate$ + utf8.bytes swap$ #1 substring$
}

% int -> byte
% constant used: utf8.bytes
FUNCTION {int.to.byte.prefix110}
{
  duplicate$ + #3 - utf8.bytes swap$ #1 substring$
}

% int -> byte
% constant used: utf8.bytes
FUNCTION {int.to.byte.prefix1110}
{
  duplicate$ duplicate$ + + #126 + utf8.bytes swap$ #1 substring$
}

% int -> byte
% constant used: utf8.bytes
FUNCTION {int.to.byte.prefix11110}
{
  #2 mult.power2 #174 + utf8.bytes swap$ #1 substring$
}

% int -> char
% variables used: a, b
% constant used: utf8.bytes
FUNCTION {unicode.to.char}
{
  duplicate$ #128 <
    'int.to.chr$
    {
      duplicate$ #2048 <
        {
          #6 div.power2
          int.to.byte.prefix110 swap$
          int.to.byte.prefix10 *
        }
        {
          duplicate$ #65536 <
            {
              #6 div.power2
              #6 div.power2
              int.to.byte.prefix1110 swap$
              int.to.byte.prefix10 * swap$
              int.to.byte.prefix10 *
            }
            {
              #6 div.power2
              #6 div.power2
              #6 div.power2
              int.to.byte.prefix11110 swap$
              int.to.byte.prefix10 * swap$
              int.to.byte.prefix10 * swap$
              int.to.byte.prefix10 *
            }
          if$
        }
      if$
    }
  if$
}

% int -> str
FUNCTION {self.tokens}
{
  #0 =
    'default.self.tokens
    'range.separators
  if$
}

% str, int -> token: str, rest: str
% variables used: s, t, b
FUNCTION {tokenize.by.bak}
{
  'b :=
  's :=

  b self.tokens s get.first.char.from.str is.char.in.str
    { s split.first.char.from.str swap$ }
    {
      ""
      { " " b self.tokens * s get.first.char.from.str is.char.in.str
        s empty$ or
        not }
        {
          s split.first.char.from.str
          duplicate$ "{" =
            { swap$ find.match.brace }
            'swap$
          if$
          's := *
        }
      while$
      s
    }
  if$
}

% str, int -> token: str, rest: str
% variables used: s, t, b
FUNCTION {tokenize.by}
{
  'b :=
  's :=

  s "" =
    { "" "" }
    {
      s split.first.char.from.str
      duplicate$ b self.tokens swap$ is.char.in.str
        'swap$
        {
          duplicate$ #92 int.to.chr$ =
            { swap$ skip.inter.token.command 's := * s }
            {
              pop$ pop$ "" s
              { duplicate$ "" = not }
              {
                split.first.char.from.str
                duplicate$ "\ " b self.tokens * swap$ is.char.in.str
                  { pop$ pop$ "" }
                  {
                    duplicate$ "{" =
                      { swap$ find.match.brace }
                      'swap$
                    if$
                    's := * s
                  }
                if$
              }
              while$
              pop$ s
            }
          if$
        }
      if$
    }
  if$
}

% str -> str
% variables used: s, t, b
FUNCTION {tokenize}
{
  #0 tokenize.by
}

% str -> str
% variables used: s, t
FUNCTION {tokenize2}
{
  tokenize swap$
}

% str -> str
% variables used: s, t, b
FUNCTION {smart.sentence.case}
{
  tokenize 's :=

  { s "" = not }
    {
      s skip.inter.token.chars 's := * s
      tokenize swap$
      duplicate$ ":" =
        {
          swap$ 's := *
          s skip.inter.token.chars 's := * s
          tokenize swap$
          lowercase.word.after.colon
            {
              duplicate$ "A" =
                { pop$ "a" }
                'lower.token.if.in.title.case
              if$
            }
            'skip$
          if$
        }
        'lower.token.if.in.title.case
      if$
      swap$ 's := *
    }
  while$
}

% str -> str
% variables used: s, t, b
FUNCTION {smart.upper.case}
{
  s swap$ t swap$

  "" swap$
  { duplicate$ "" = not }
    {
      tokenize swap$
      duplicate$ #1 #1 substring$ #92 int.to.chr$ =
        'skip$
        {
          "" swap$
          { duplicate$ "" = not }
            {
              split.first.tex.char.from.str
              duplicate$ "{" =
                { swap$ find.match.brace }
                { tex.to.upper swap$ }
              if$
              't := * t
            }
          while$
          pop$
        }
      if$
      swap$ 't := * t
      skip.inter.token.chars 't := * t
    }
  while$
  pop$

  swap$ 't :=
  swap$ 's :=
}

% char -> char
% variable used: b
FUNCTION {to.collation}
{
  duplicate$ char.to.unicode
  duplicate$ #19968 swap$ #40959 swap$ is.int.in.range
    {
      #19967 - duplicate$ duplicate$ + + #2 -
      utf8.collation swap$ #3 substring$ swap$
    }
    'skip$
  if$
  pop$
}

% str -> str
% variables used: t, b
FUNCTION {all.to.collation}
{
  "" swap$
  { duplicate$ empty$ not }
    { split.first.char.from.str to.collation swap$ 't := * t }
  while$
  *
}

% ====================================
% The following part is only for tests
% ====================================

FUNCTION {newline}
{
  #10 int.to.chr$
}

FUNCTION {assert.str}
{
  't :=
  's :=
  s t =
    'skip$
    {
      newline
      "Assertion `" * s * " = " * t * "` failed" *
      newline *
      "when testing function `" *
      current.test * "`." *
      warning$
    }
  if$
}

FUNCTION {assert.int}
{
  'b :=
  'a :=
  a b =
    'skip$
    {
      newline
      "Assertion `" * a int.to.str$ * " = " * b int.to.str$ * "` failed" *
      newline *
      "when testing function `" *
      current.test * "`." *
      warning$
    }
  if$
}

FUNCTION {run.tests}
{
  "mult.power2" 'current.test :=

  #1 #6 mult.power2 #64 assert.int
  #3 #4 mult.power2 #48 assert.int
  #5 #10 mult.power2 #5120 assert.int

  "char.to.unicode" 'current.test :=

  "/" char.to.unicode #47 assert.int
  "À" char.to.unicode #192 assert.int
  "我" char.to.unicode #25105 assert.int
  "😓" char.to.unicode #128531 assert.int

  "unicode.to.char" 'current.test :=

  #58 unicode.to.char ":" assert.str
  #201 unicode.to.char "É" assert.str
  #30922 unicode.to.char "磊" assert.str
  #128525 unicode.to.char "😍" assert.str

  "is.upper.ascii" 'current.test :=

  "L" is.upper.ascii #1 assert.int
  "À" is.upper.ascii #0 assert.int
  "é" is.upper.ascii #0 assert.int
  "我" is.upper.ascii #0 assert.int

  "is.upper" 'current.test :=

  "L" is.upper #1 assert.int
  "À" is.upper #1 assert.int
  "é" is.upper #0 assert.int
  "我" is.upper #0 assert.int

  "is.lower.ascii" 'current.test :=

  "z" is.lower.ascii #1 assert.int
  "č" is.lower.ascii #0 assert.int
  "Ã" is.lower.ascii #0 assert.int
  "H" is.lower.ascii #0 assert.int
  "ô" is.lower.ascii #0 assert.int

  "is.lower" 'current.test :=

  "z" is.lower #1 assert.int
  % TODO: Currently only chars in latin1 are  supported
  % "č" is.lower #1 assert.int
  "Ã" is.lower #0 assert.int
  "H" is.lower #0 assert.int
  "ô" is.lower #1 assert.int

  "is.letter.ascii" 'current.test :=

  "z" is.letter.ascii #1 assert.int
  "č" is.letter.ascii #0 assert.int
  "L" is.letter.ascii #1 assert.int
  "我" is.letter.ascii #0 assert.int
  "," is.letter.ascii #0 assert.int
  "'" is.letter.ascii #0 assert.int
  "`" is.letter.ascii #0 assert.int

  "is.symbol.ascii" 'current.test :=

  "z" is.symbol.ascii #0 assert.int
  "č" is.symbol.ascii #0 assert.int
  "L" is.symbol.ascii #0 assert.int
  "我" is.symbol.ascii #0 assert.int
  "," is.symbol.ascii #1 assert.int
  "'" is.symbol.ascii #1 assert.int
  "`" is.symbol.ascii #1 assert.int
  % "" is.symbol.ascii #0 assert.int

  "is.all.upper" 'current.test :=

  "fooé" is.all.upper #0 assert.int
  "FOOÉ" is.all.upper #1 assert.int
  "FOOé" is.all.upper #0 assert.int
  "{\relax { Foo} baz}" is.all.upper #0 assert.int
  "{\relax { FOO} BAZ}" is.all.upper #1 assert.int

  "is.all.lower" 'current.test :=

  "{\relax { foo} baz}" is.all.lower #1 assert.int
  "fooé" is.all.lower #1 assert.int

  "is.in.title.case" 'current.test :=

  "foobar" is.in.title.case #0 assert.int
  "Foobar" is.in.title.case #1 assert.int
  "{\v C}oobar" is.in.title.case #1 assert.int

  "skip.inter.token.chars.by" 'current.test :=

  "   to baz" #0 skip.inter.token.chars.by
  "to baz" assert.str
  "   " assert.str
  "   " #0 skip.inter.token.chars.by
  "" assert.str
  "   " assert.str
  "--127" #1 skip.inter.token.chars.by
  "127" assert.str
  "--" assert.str
  "–～127" #1 skip.inter.token.chars.by
  "127" assert.str
  "–～" assert.str
  "H {C}a{d{e}}}" #2 skip.inter.token.chars.by
  " {C}a{d{e}}}" assert.str
  "H" assert.str

  "skip.inter.token.chars" 'current.test :=

  "MapReduce" skip.inter.token.chars "MapReduce" assert.str "" assert.str
  "" skip.inter.token.chars "" assert.str "" assert.str


  "skip.inter.token.command" 'current.test :=

  "csname {C}a{d{e}}}" skip.inter.token.command
  " {C}a{d{e}}}" assert.str
  "csname" assert.str
  "csname" skip.inter.token.command
  "" assert.str
  "csname" assert.str

  "to.lower" 'current.test :=

  "H" to.lower "h" assert.str
  "Ë" to.lower "ë" assert.str
  "我" to.lower "我" assert.str

  "to.upper" 'current.test :=

  "h" to.upper "H" assert.str
  "ë" to.upper "Ë" assert.str
  "我" to.upper "我" assert.str

  "tex.to.lower" 'current.test :=

  "H" tex.to.lower "h" assert.str
  "Ë" tex.to.lower "ë" assert.str
  "我" tex.to.lower "我" assert.str
  "{\v {C}a{d{e}}}" tex.to.lower "{\v {c}a{d{e}}}" assert.str
  "{\H {C}a{d{e}}}" tex.to.lower "{\H {c}a{d{e}}}" assert.str
  "{\` {C}a{d{e}}}" tex.to.lower "{\` {c}a{d{e}}}" assert.str

  "lower.token.if.in.title.case" 'current.test :=

  "Foobar" lower.token.if.in.title.case "foobar" assert.str
  "FOOBAR" lower.token.if.in.title.case "FOOBAR" assert.str
  "fooBar" lower.token.if.in.title.case "fooBar" assert.str
  "{\v {C}a{d{e}}}o" lower.token.if.in.title.case "{\v {c}a{d{e}}}o" assert.str
  "{\H {C}a{d{e}}}o" lower.token.if.in.title.case "{\H {c}a{d{e}}}o" assert.str
  "{\H {C}a{d{e}}}O" lower.token.if.in.title.case "{\H {C}a{d{e}}}O" assert.str
  "{\` {E}a{d{e}}}o" lower.token.if.in.title.case "{\` {e}a{d{e}}}o" assert.str

  "find.match.brace" 'current.test :=

  "{" "OLAP} Foo" find.match.brace " Foo" assert.str "{OLAP}" assert.str
  % "{" "{OLAP {bar}" find.match.brace
  % "" assert.str
  % "{{OLAP {bar}}}" assert.str

  "tokenize" 'current.test :=

  "Foobar 2000" tokenize " 2000" assert.str "Foobar" assert.str
  "{Foobar 2000}" tokenize "" assert.str "{Foobar 2000}" assert.str
  "Fo{obar   2} 000" tokenize " 000" assert.str "Fo{obar   2}" assert.str
  "-User   " tokenize "User   " assert.str "-" assert.str
  "" tokenize "" assert.str "" assert.str
  " " tokenize " " assert.str "" assert.str
  "Demtr{" #92 int.to.chr$ * quote$ * "o}der and Bekcer" * tokenize
  " and Bekcer" assert.str
  "Demtr{" #92 int.to.chr$ * quote$ * "o}der" * assert.str

  "smart.sentence.case" 'current.test :=

  "      Providing   OLAP to User-Analysts: An IT Mandate MapReduce and HPC Systems   "
  smart.sentence.case
  "      providing   OLAP to user-analysts: an IT mandate MapReduce and HPC systems   "
  assert.str
  "The Research University's Dilemma: Resource Sharing and Research in a Transinstitutional Environment"
  smart.sentence.case
  "The research university's dilemma: resource sharing and research in a transinstitutional environment"
  assert.str
  "Perturbations in the A {$^1\Sigma_u^+$} state of Na$_2$" smart.sentence.case
  "Perturbations in the A {$^1\Sigma_u^+$} state of Na$_2$" assert.str
  "Perturbations in the A $\Sigma_u^+$ state of Na$_2$" smart.sentence.case
  "Perturbations in the A $\Sigma_u^+$ state of Na$_2$" assert.str
  % "Perturbations in the A Mega{sigma${u}^+$} state of Na$_2$" smart.sentence.case
  % "Perturbations in the A Mega{sigma{u}+} state of Na$_2$" assert.str

  "smart.upper.case" 'current.test :=

  "Barthélemy, M." smart.upper.case "BARTHÉLEMY, M." assert.str
  "Kusch, P" smart.upper.case "KUSCH, P" assert.str
  "Atkinson, J B" smart.upper.case "ATKINSON, J B" assert.str
  "Demtr{" #92 int.to.chr$ * quote$ * "o}der, W" * smart.upper.case
  "DEMTR{" #92 int.to.chr$ * quote$ * "O}DER, W" * assert.str
}

FUNCTION {init.consts}
{
  #1 'lowercase.word.after.colon :=
  % #0 'token.state :=
  % #0 'inter.token.state :=
  % "{\relax { foo} baz}" "u" change.case$ top$
  % "{\v {C}a{d{e}}}o" #1 text.prefix$ purify$ top$
  % "{\v {C}a{d{e}}}o" split.first.tex.char.from.str stack$
  % "{v {C}a{d{e}}}o" split.first.tex.char.from.str stack$
  % "\Foobar200 haha" tokenize stack$
  % "" is.symbol.ascii top$
  % "Perturbations in the A {$^1\Sigma_u^+$} state of Na$_2$" smart.sentence.case top$
  % "Perturbations in the A $\Sigma_u^+$ state of Na$_2$" smart.sentence.case top$
  % "{" text.length$ top$
  % "Perturbations in the A Sigma+ state of Na$_2$" smart.sentence.case top$
  % "" skip.inter.token.command stack$
}

READ

EXECUTE {init.consts}

EXECUTE {run.tests}
