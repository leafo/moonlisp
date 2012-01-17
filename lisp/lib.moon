
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
  switch type item
    when "table"
      flat = [pretty_format i for i in *flatten_list item]
      "(" .. table.concat(flat, " ") .. ")"
    when "string"
      ("%q")\format item
    when "nil"
      "nil"
    else
      item

export *

__splice = (val, tail) ->
  append val, tail

consp = (arg) -> type(arg) == "table"
listp = (arg) -> type(arg) == "table" or arg == nil

null = (arg) -> arg == nil
atom = (arg) -> not consp arg

zerop = (arg) -> arg == 0

nth = (n, lst) ->
  while n > 0
    return nil if not lst
    lst = lst[2]
    n -= 1

  lst[1]

-- tests if a,b represent the same thing
equal = (a, b) ->
  t = type a
  return false if t != type b
  if t == "table"
    equal(a[1], b[1]) and equal a[2], b[2]
  else
    a == b

reverse = (lst) ->
  assert listp(lst), "reverse takes one list"
  new = nil
  while lst
    new = {lst[1], new}
    lst = lst[2]
  new

append = (a, b) ->
  assert listp(a) and listp(b), "append takes two lists"
  a = reverse a
  while a
    b = {a[1], b}
    a = a[2]
  b

p = (...) ->
  args = {...} -- ugh fix me
  print if #args == 0
    "nil"
  else
    unpack [pretty_format x for x in *args]

