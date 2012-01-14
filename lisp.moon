
require "lpeg"

import run_with_scope from require "moon"
import P, V, S, R, C from lpeg

lisp = [[(+ 1 2)]]

auto_variable = (fn) ->
  env = getfenv fn
  setfenv fn, setmetatable {}, {
    __index: (name) =>
      return env[name] if env[name]
      print "getting name:", name
      V name if name\match "^[A-Z]"
  }
  fn!

White = S" \t\r\n"^0

sym = (s) -> White * s

parser = auto_variable ->
  P {
    Statements

    Statements: SExp^0

    Number: White * C R"09"^0
    Atom: White * C (R("az", "AZ", "09") + S"-_*/+=")^1
    String: sym""

    SExp: sym"(" * SExp^0 * sym")"
  }


print parser\match [[
  (()) (  )
  ()
]]


