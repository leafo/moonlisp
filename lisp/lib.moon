
export *

consp = (arg) -> type(arg) == "table"
listp = (arg) -> type(arg) == nil or arg == nil
null = (arg) -> arg == nil

-- tests if a,b represent the same thing
equal = (a, b) ->
  t = type a
  return false if t != type b
  if t == "table"
    equal(a[1], b[1]) and equal a[2], b[2]
  else
    a == b

