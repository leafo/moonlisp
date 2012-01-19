
module "lisp.types", package.seeall

import p from require"moon"

export *

atom = (exp) ->
  assert exp and exp[1] == "atom", "expecting atom"
  exp[2]

list = (exp) ->
  assert exp and exp[1] == "list", "expecting list"
  exp[2]

fncall_name = (exp) ->
  a = exp and exp[1] == "list" and exp[2][1]
  atom a if a and a[1] == "atom"

