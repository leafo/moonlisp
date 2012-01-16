require("moonscript")
require("lisp.lib");
(function()
  local x = 1
  local y = 2
  return print((x + y))
end)();
(function()
  local x = "hello"
  local y = "world"
  print("okay")
  print(y)
  return print(x)
end)()