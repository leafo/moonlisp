
module "lisp.types", package.seeall

import p from require"moon"
import insert from table

lua_type = type

export *

symbol_metatable = {
  __tostring: => self[1]
}

type = (val) ->
  real_type = lua_type val
  if real_type == "table"
    return "symbol" if is_symbol val
    real_type
  else
    real_type

flatten_list = (lst) ->
  flat = {}
  current = lst
  while current
    insert flat, current[1]
    current = current[2]

  flat

is_symbol = (val) ->
  symbol_metatable == getmetatable val

atom = (exp) ->
  assert exp and exp[1] == "atom", "expecting atom, got: " .. pretty_format exp
  exp[2]

list = (exp) ->
  assert exp and exp[1] == "list", "expecting list"
  exp[2]

fncall_name = (exp) ->
  a = exp and exp[1] == "list" and exp[2][1]
  atom a if a and a[1] == "atom"

-- quotes string
quote_string = (str) ->
  str = ("%q")\format(str)\sub 2, -2
  {"string", '"', str}


pretty_format = (item) ->
  switch type item
    when "symbol"
      "'" .. item[1]
    when "table"
      flat = [pretty_format i for i in *flatten_list item]
      "(" .. table.concat(flat, " ") .. ")"
    when "string"
      ("%q")\format item
    when "nil"
      "nil"
    else
      tostring item

