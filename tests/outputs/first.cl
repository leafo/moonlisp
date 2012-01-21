require("moonscript")
require("lisp.lib");
(function()
  hello = {
    __S("balls"),
    {
      __S("land"),
      nil
    }
  }
  return hello
end)()
print("hello")
_ = ((1 + 2) * 4 * 4 * 2);
(function()
  x = "hello"
  return x
end)();
(function()
  hello = function(x, y)
    _ = (2 + 3 + 4)
    return print(__S("hi"))
  end
  return hello
end)()
_ = {
  1,
  {
    3,
    {
      nil
    }
  }
}
print((({
  1,
  {
    4,
    {
      2,
      nil
    }
  }
})[2])[1])
_ = hello[1]
_ = 3 == 4 and 4 == 5
_ = ({
  1,
  {
    2,
    {
      3,
      nil
    }
  }
})[1];
(function()
  hello = function(x, h)
    return 34
  end
  return hello
end)()