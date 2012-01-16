require("moonscript")
require("lisp.lib");
(function()
  has_list = function(lst)
    return (not null(lst) and (listp(lst[1]) or has_list(lst[2])))
  end
  return has_list
end)()
print(has_list({
  1,
  {
    2,
    {
      3,
      {
        4,
        nil
      }
    }
  }
}))
print(has_list({
  1,
  {
    nil,
    {
      3,
      {
        4,
        nil
      }
    }
  }
}))