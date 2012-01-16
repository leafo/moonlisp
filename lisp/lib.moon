
require "moon"

import insert from table

flatten_list = (lst) ->
  flat = {}
  current = lst
  while current
    insert flat, current[1]
    current = current[2]

  flat

pretty_format = (item) ->
  t = type item
  if t == "table"
    flat = [pretty_format i for i in *flatten_list item]
    "(" .. table.concat(flat, " ") .. ")"
  elseif t == "string"
    ("%q")\format item
  else
    item

export *

consp = (arg) -> type(arg) == "table"
listp = (arg) -> type(arg) == nil or arg == nil
null = (arg) -> arg == nil

zerop = (arg) -> arg == 0

-- tests if a,b represent the same thing
equal = (a, b) ->
  t = type a
  return false if t != type b
  if t == "table"
    equal(a[1], b[1]) and equal a[2], b[2]
  else
    a == b

p = (...) ->
  args = {...} -- ugh fix me
  print unpack [pretty_format x for x in *args]

