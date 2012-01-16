require("moonscript")
require("lisp.lib");
(function()
  compress = function(x)
    return (function()
      if consp(x) then
        return compr(x[1], 1, x[2])
      else
        return x
      end
    end)()
  end
  return compress
end)();
(function()
  n_elts = function(el, n)
    return (function()
      if (n > 1) then
        return {
          n,
          {
            el,
            nil
          }
        }
      else
        return el
      end
    end)()
  end
  return n_elts
end)();
(function()
  compr = function(el, n, lst)
    return (function()
      if null(lst) then
        return {
          n_elts(el, n),
          nil
        }
      else
        return (function()
          local next = lst[1]
          return (function()
            if next == el then
              return compr(el, (n + 1), lst[2])
            else
              return {
                n_elts(el, n),
                compr(next, 1, lst[2])
              }
            end
          end)()
        end)()
      end
    end)()
  end
  return compr
end)();
(function()
  input = {
    1,
    {
      1,
      {
        1,
        {
          0,
          {
            1,
            {
              0,
              {
                0,
                {
                  0,
                  {
                    0,
                    {
                      1,
                      nil
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return input
end)()
print("input")
p(input)
print("compress")
p(compress(input));
(function()
  uncompress = function(lst)
    return (function()
      if null(lst) then
        return nil
      else
        return (function()
          local next = lst[1]
          return (function()
            if consp(next) then
              return flatten(next[1], (next[2])[1], lst[2])
            else
              return {
                next,
                uncompress(lst[2])
              }
            end
          end)()
        end)()
      end
    end)()
  end
  return uncompress
end)();
(function()
  flatten = function(n, val, remaining)
    return (function()
      if zerop(n) then
        return uncompress(remaining)
      else
        return {
          val,
          flatten((n - 1), val, remaining)
        }
      end
    end)()
  end
  return flatten
end)()
print("uncompress")
p(uncompress(compress(input)))