
module "lisp.types", package.seeall

import p from require"moon"
import insert from table

export *

flatten_list = (lst) ->
  flat = {}
  current = lst
  while current
    insert flat, current[1]
    current = current[2]

  flat

atom = (exp) ->
  assert exp and exp[1] == "atom", "expecting atom"
  exp[2]

list = (exp) ->
  assert exp and exp[1] == "list", "expecting list"
  exp[2]

fncall_name = (exp) ->
  a = exp and exp[1] == "list" and exp[2][1]
  atom a if a and a[1] == "atom"

