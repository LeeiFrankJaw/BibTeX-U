ENTRY {title}{}{}

INTEGERS { lowercase.word.after.colon }

STRINGS { current.test }

STRINGS { s t }

INTEGERS { a b }

FUNCTION {default.self.tokens} { ":-,.!?'" }

FUNCTION {latin1.upper} { "ÀÁÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸ" }

FUNCTION {latin1.lower} { "àáãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ" }

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

% str -> str, char|""
FUNCTION {split.first.char.from.str}
{
  duplicate$ "" =
    { "" }
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

% str -> char|""
FUNCTION {get.first.char.from.str}
{
  split.first.char.from.str swap$ pop$
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
            { #1 #1 substring$ chr.to.int$ }
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

% str, char|"" -> bool
% variable used: t
% return false if 2nd arg is ""
FUNCTION {is.char.in.str}
{
  't :=
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
    {
      char.to.unicode duplicate$
      #192 swap$ #214 swap$ is.int.in.range swap$
      #216 swap$ #222 swap$ is.int.in.range or
    }
  if$
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
    {
      char.to.unicode duplicate$
      #223 swap$ #246 swap$ is.int.in.range swap$
      #248 swap$ #255 swap$ is.int.in.range or
    }
  if$
}

% str -> bool
% variable used: b
% return true if str is empty
FUNCTION {is.all.lower}
{
  #1 swap$
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
    { latin1.lower swap$ latin1.upper swap$ map.char }
  if$
}

% char -> char
% variables used: t, b
FUNCTION {to.upper}
{
  duplicate$ is.lower.ascii
    { chr.to.int$ #32 - int.to.chr$ }
    { latin1.upper swap$ latin1.lower swap$ map.char }
  if$
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

  #0 >
    { "Unbalanced brace(s): one or more closing braces are missing" warning$ }
    'skip$
  if$

  t
  s
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
    { split.first.char.from.str to.lower swap$ * }
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

% str, str -> str, str
FUNCTION {smart.sentence.case.inter.token}
{
  { duplicate$ #1 #1 substring$ " " = }
    {
      #2 global.max$ substring$ swap$
      " " * swap$
    }
  while$
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
FUNCTION {tokenize.by}
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

% str -> str
% variables used: s, t, b
FUNCTION {tokenize}
{
  #0 tokenize.by
}

% str -> str
% variables used: s, t, b
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
      s smart.sentence.case.inter.token
      tokenize swap$
      duplicate$ ":" =
        {
          swap$ 's := *
          s smart.sentence.case.inter.token
          tokenize swap$
          lowercase.word.after.colon
            {
              duplicate$ "A" =
                'to.lower
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

FUNCTION {assert}
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

FUNCTION {run.tests}
{
  "mult.power2" 'current.test :=

  #1 #6 mult.power2 int.to.str$ #64 int.to.str$ assert
  #3 #4 mult.power2 int.to.str$ #48 int.to.str$ assert
  #5 #10 mult.power2 int.to.str$ #5120 int.to.str$ assert

  "char.to.unicode" 'current.test :=

  "/" char.to.unicode int.to.str$ #47 int.to.str$ assert
  "À" char.to.unicode int.to.str$ #192 int.to.str$ assert
  "我" char.to.unicode int.to.str$ #25105 int.to.str$ assert
  "😓" char.to.unicode int.to.str$ #128531 int.to.str$ assert

  "unicode.to.char" 'current.test :=

   #58 unicode.to.char ":" assert
   #201 unicode.to.char "É" assert
   #30922 unicode.to.char "磊" assert
   #128525 unicode.to.char "😍" assert

  "lower.token.if.in.title.case" 'current.test :=

  "Foobar" lower.token.if.in.title.case "foobar" assert
  "foobar" lower.token.if.in.title.case "foobar" assert
  "fooBar" lower.token.if.in.title.case "fooBar" assert

  "" 'current.test :=
}

FUNCTION {init.consts}
{
  #1 'lowercase.word.after.colon :=
}

READ

EXECUTE {init.consts}

EXECUTE {run.tests}
