
module "lisp.parse", package.seeall

require "lpeg"

import run_with_scope, p from require "moon"
import P, V, S, R, C, Cc, Ct from lpeg

White = S" \t\r\n"^0
Comment =  ";" * (1 - S"\r\n")^0 * S"\r\n"
White = White * (Comment * White)^0

sym = (s) -> White * s

mark = (name) -> (...) -> { name, ... }

auto_variable = (fn) ->
  run_with_scope fn, setmetatable {}, {
    __index: (name) =>
      V name if name\match "^[A-Z]"
  }

-- find out if it is inefficient to do whitespace first?
parser = auto_variable ->
  P {
    Code

    Code: Ct(Value^0) * White * -1

    Number: White * C(R"09"^1) / mark"number"
    Atom: White * C((R("az", "AZ", "09") + S"-_*/+=<>%")^1) / mark"atom"
    String: White * C(sym'"') * C((P"\\\\" + '\\"' + (1 - S'"\r\n'))^0) * '"' / mark"string"
    Quote: White * (P"'" + "`") * Value / mark"quote"
    Unquote: sym"," * (P"@" * Value / mark"unquote_splice" + Value / mark"unquote" )

    SExp: sym"(" * Ct(Value^0) * sym")" / mark"list"

    Value: Number + String + SExp + Quote + Unquote + Atom
  }


export parse = (lisp_code) ->
  parser\match lisp_code

